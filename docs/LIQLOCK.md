# SHAMBA LUV Liquidity Lock — Technical Documentation

**Live web publication:** https://luv.pythai.net/liqlock.html — the public proof page, where every
number is read from Ethereum by the visitor's own browser. No wallet, no consent, no trust required.

**Status: THE LIQUIDITY IS LOCKED.** As of 2026-08-24, **100% of the circulating LUV/WETH
Uniswap V2 LP** is held by an ownerless, extend-only timelock. The treasury's LP balance is
**exactly 0**.

## Table of Contents
1. [The claim, and how to refute it](#the-claim-and-how-to-refute-it)
2. [The addresses](#the-addresses)
3. [The locks](#the-locks)
4. [The contract — what makes it a lock](#the-contract--what-makes-it-a-lock)
5. [How it was deployed](#how-it-was-deployed)
6. [The paper trail](#the-paper-trail)
7. [Maturity and the re-lock plan](#maturity-and-the-re-lock-plan)
8. [Verify it yourself](#verify-it-yourself)
9. [Evidence chain](#evidence-chain)

## The claim, and how to refute it

"The liquidity is locked" is not a statement of intent. It is a pair of `eth_call`s anyone can repeat:

```
total_locked(pair)  on the locker  == 16,419,484,360,707,141,173,121,139  (100% of circulating LP)
pair.balanceOf(treasury)           == 0
```

If either query ever returns otherwise while the locks are live, the claim is refuted. The proof
page performs both queries live, in the reader's own browser: https://luv.pythai.net/liqlock.html

## The addresses

| | address | |
|---|---|---|
| **the locker** | `0x111111f70cb3469B5285862d7a4e7Cb53d04f502` | [verified source ↗](https://etherscan.io/address/0x111111f70cb3469B5285862d7a4e7Cb53d04f502#code) — the green checkmark |
| the LUV/WETH pair | `0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31` | [Uniswap V2 ↗](https://etherscan.io/address/0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31) — where the price is created |
| the LUV token | `0x2711111111683B8708cb9a48cBf36a51315F8254` | [verified ↗](https://etherscan.io/token/0x2711111111683B8708cb9a48cBf36a51315F8254) |
| beneficiary | `0x10f7Ee226B16bea7f365Dc1eDEF159Fc1957D169` | the treasury (bankon.eth) — the only key that can extend, assign, or (at maturity) withdraw |

The locker's six leading 1s — the repunit, LUV's own motif — are a **mined CREATE3 salt**, not
luck, and not a different trust story: the contract has no owner regardless of who deployed it.

## The locks

| | lock #0 — the rehearsal | lock #1 — the position |
|---|---|---|
| amount | 0.001 LP (`1000000000000000` wei) | **16,419,484.359707 LP** (`16419484359707141173121139` wei) |
| share | dust | **100% of circulating LP** (with #0: totalSupply − burned `MINIMUM_LIQUIDITY`) |
| transaction | [`0x30748af2…0b72`](https://etherscan.io/tx/0x30748af283c482f0bc8746e53f9f40ce1496ed4c6e64c46d5839a25f03670b72) · block 25,827,695 | [`0xc2c3c73d…390d`](https://etherscan.io/tx/0xc2c3c73d2bfa216807e900abb17eff4a98808b45768cf11f23e829e52a10390d) · block 25,827,873 |
| matures | 2026-11-22T21:21:11Z | **2026-11-22T21:57:23Z** |
| gates | time only (90 days) | time only (90 days) — a block gate can be *added*, never removed |

The dust rehearsal came first, deliberately: approve → pull → lock → read back, end to end on
mainnet with 0.001 LP, before the position committed. After lock #1,
`total_locked(pair) == pair.balanceOf(locker)` **to the wei** — the contract's books equal the
live balance, which is invariant 1 of its test suite holding in production.

## The contract — what makes it a lock

`liquidity_locker` (repo: [SHAMBA-LUV/liq-locker](https://github.com/SHAMBA-LUV/liq-locker)) is an
ownerless ERC-20 timelock built to hold an AMM pair token:

- **No owner, anywhere.** No pause, no rescue, no setter, no proxy, no `delegatecall`, no
  `SELFDESTRUCT`, no `tx.origin`. Nobody — including the deployer — can bring a maturity forward.
- **Extend-only, always.** The beneficiary may lengthen a lock (`extend_default` +90d on the
  *current* maturity, `extend_by`, absolute `extend`), add a block-height gate, reassign
  (`assign` — succession without a trust gap), or withdraw after maturity. There is no shortening
  path, for anyone.
- **Two gates.** A lock binds by time, block height, or both — it opens only when the **later**
  gate has passed. A clock cannot open it early; a stalling chain cannot strand it.
- **Holds any ERC-20.** Credits the *measured balance delta* (fee-on-transfer safe), caps
  `received` at `amount` (reflection/rebase-up safe — the C-1 correction proven executable in
  [SHAMBA-LUV/vesting](https://github.com/SHAMBA-LUV/vesting)), handles USDT-style no-return
  tokens, and blocks reentrancy. A permissionless `sweep_surplus` rescues stray tokens but can
  never reach locked principal or booked interest — arithmetic, not permission.
- **Built to [cypherpunk4096](https://github.com/cypherpunk4096/standard)**: deterministic
  identity, zero dependencies, verification over trust, precision without approximation.

## How it was deployed

Via **Create3d** (`0xa5A2581d564248801cc5e06DbB764c99c170320A`), the deterministic deployer:
the address is `f(factory, deployer, salt)` — independent of bytecode and constructor arguments —
and salts are **namespaced by sender**, so `0x111111f7…f502` is reproducible on **every EVM
chain** and claimable by the treasury alone. Salt: `liq-locker.piscixoq`
(`bytes32 = keccak256(saltString)`).

- Deploy tx: [`0x113ba138…f38d`](https://etherscan.io/tx/0x113ba138d140f7ec0ca75c8697d69b7e8a931d508515ded6cee1523c5627f38d) · block 25,822,914 · 1,922,491 gas
- Build: solc 0.8.24, optimizer 200, via-IR, EVM **paris** (deliberate: identical bytecode runs on
  every chain, including those that never adopted shanghai)
- Constructor: `SURPLUS_SINK = the treasury` — the one immutable argument
- Source verification: **Pass — Verified** on Etherscan; the on-chain runtime matched the repo
  build byte-for-byte before submission
- Full narrative: [liq-locker/docs/DEPLOYMENT.md](https://github.com/SHAMBA-LUV/liq-locker/blob/main/docs/DEPLOYMENT.md) ·
  machine-readable record: [liq-locker/deploy/mainnet.json](https://github.com/SHAMBA-LUV/liq-locker/blob/main/deploy/mainnet.json)

## The paper trail

Transactions, not claims — in order:

1. **Deploy** — [`0x113ba138…f38d`](https://etherscan.io/tx/0x113ba138d140f7ec0ca75c8697d69b7e8a931d508515ded6cee1523c5627f38d) (block 25,822,914): Create3d → the locker at its deterministic address
2. **Approve** — [`0xf2ab3e27…c422`](https://etherscan.io/tx/0xf2ab3e27efd82cee3cc57c17397119a57d2d6b8615304405f12d1451a963c422) (block 25,827,621): the pair permits the locker to pull LP
3. **Lock #0** — [`0x30748af2…0b72`](https://etherscan.io/tx/0x30748af283c482f0bc8746e53f9f40ce1496ed4c6e64c46d5839a25f03670b72) (block 25,827,695): the 0.001 LP dust rehearsal
4. **Lock #1** — [`0xc2c3c73d…390d`](https://etherscan.io/tx/0xc2c3c73d2bfa216807e900abb17eff4a98808b45768cf11f23e829e52a10390d) (block 25,827,873): **the full position; treasury LP → 0**

The per-address ledger is kept in
[liq-locker/.history/](https://github.com/SHAMBA-LUV/liq-locker/tree/main/.history).

## Maturity and the re-lock plan

Both locks mature **2026-11-22** (the 90-day launch-sequence cadence). Published before the fact,
as the runbook requires:

- **Diary: T−30 = 2026-10-23 · T−7 = 2026-11-15**
- **The plan:** `extend_default(1)` — +90 days measured from the *current* maturity, signed by the
  beneficiary before 2026-11-22. Extension is one-way; a lock at the 200-year horizon is reachable
  a quarter at a time, and nothing can ever pull a date back in.
- The beneficiary key is re-checked at each diary date — locks outlive the wallets people expect
  them to, and `assign()` succession exists for exactly that.

## Verify it yourself

No tooling beyond a public RPC:

```sh
# 100% of circulating LP held by the locker
cast call 0x111111f70cb3469B5285862d7a4e7Cb53d04f502 \
  "total_locked(address)(uint256)" 0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31 \
  --rpc-url https://ethereum-rpc.publicnode.com

# the treasury holds zero LP
cast call 0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31 \
  "balanceOf(address)(uint256)" 0x10f7Ee226B16bea7f365Dc1eDEF159Fc1957D169 \
  --rpc-url https://ethereum-rpc.publicnode.com

# lock #1, in full: (token, beneficiary, amount, unlock_at, withdrawn)
cast call 0x111111f70cb3469B5285862d7a4e7Cb53d04f502 \
  "lock_at(uint256)(address,address,uint256,uint48,bool)" 1 \
  --rpc-url https://ethereum-rpc.publicnode.com
```

Or simply open **https://luv.pythai.net/liqlock.html** — the page runs the same calls from the
reader's browser, refreshing every 60 seconds, and links every address to its verified source.

## Evidence chain

- **186 tests** ([test.md](https://github.com/SHAMBA-LUV/liq-locker/blob/main/test.md)): 171
  offline including 6 stateful invariants at 32,768 calls with zero reverts, plus a 15-test
  mainnet-fork suite that locked the *real* position pre-deploy and proved redemption returns it
  **to the wei**
- **28 adversarial gate attacks** ([GATE_ATTACK_RESULTS.md](https://github.com/SHAMBA-LUV/liq-locker/blob/main/GATE_ATTACK_RESULTS.md))
- **The self-audit that names itself one** ([AUDIT.md](https://github.com/SHAMBA-LUV/liq-locker/blob/main/AUDIT.md)) —
  per the verification doctrine, an audit is never called *verified*; only the checkmark is
- **The production sheet** ([PRODUCTION.md](https://github.com/SHAMBA-LUV/liq-locker/blob/main/PRODUCTION.md)) —
  the one open box, stated plainly: no independent audit yet
- **The interaction surface** ([dapp/](https://github.com/SHAMBA-LUV/liq-locker/tree/main/dapp)) —
  the full ABI console, the lock panel, and this proof page, all wallet-free for reads

*The engine paper places this lock in the wider argument —
[engine.html §IV, the verification doctrine](https://luv.pythai.net/engine.html#s4) — and the FAQ
carries [the lock's plain-language statement](https://luv.pythai.net/faq.html). The supply lock is
a separate, future transaction; until it exists, the honest word for those allocations remains
"earmarked".*
