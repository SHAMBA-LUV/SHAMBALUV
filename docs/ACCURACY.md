# The SCIEN·TIFIC standard of accuracy

SHAMBA LUV counts the way SCIEN·TIFIC counts: every amount is a whole number of the smallest unit, and
nothing is ever rounded where the chain is exact. This page states the standard, shows it on two live
deployments, and sets out how SHAMBA LUV carries it into the distribution of rewards for CPU and GPU
contribution. Every figure below was read from the chains on **2026-11-09** at the blocks named, by
`eth_call`, as exact integers.

Marks: **live** (on chain now), **built** (in code), **proposed** (designed, not yet built).

## 1. The standard

1. **An amount is an integer of 10⁻¹⁸.** Both tokens declare `decimals() = 18`, so a balance is a
   `uint256` count of the smallest unit, and the decimal point is only where a reader puts it.
2. **Never a float.** An IEEE-754 double, the number type of JavaScript and of most spreadsheets, keeps
   15 to 17 significant digits. Off-chain code keeps amounts as integers (`BigInt` in JavaScript, `int` in
   Python, `uint256` on chain) and prints them with all 18 decimals.
3. **A 19th decimal is not an amount.** 10⁻¹⁹ of a token does not exist on chain, so a ledger refuses it
   rather than round it.
4. **Truncation is stated.** A ratio (a price) is derived by integer floor division and says so; its
   resolution is part of the reading.
5. **A small price is stated in a large unit.** At 18 decimals a price of 10⁻¹⁶ keeps only three
   significant digits, so it is quoted per 10¹² tokens, or in wei, rather than shortened.
6. **A price has a moment.** It is the state of a liquidity pair read at a stated block: price and time
   are one observation (chronos.oracle). A price without a block is a rumour.

### Three amounts, three ways

| Amount | Held on chain (base units) | Read |
|---|---|---|
| all zeros | `0` | `0.000000000000000000` |
| zeros and a trailing 1 | `1` | `0.000000000000000001` (the smallest amount that exists) |
| `.123456789123456789` | `123456789123456789` | `0.123456789123456789` |

Adding the smallest step to the third gives `0.123456789123456790`, exactly. A double holds the same
value as `0.123456789123456783797…`: the 18th digit is already wrong (3 where the amount has 9), and
adding 10⁻¹⁸ leaves it unchanged. bankML's and browseML's receipt ledgers keep amounts in this same form
(a `BigInt` of 10⁻¹⁸), so a browser ledger and a server ledger verify each other byte for byte.

## 2. SCIEN·TIFIC: one deployment, four chains (live)

SCIEN·TIFIC (`name() = "SCIEN"`, `symbol() = "TIFIC"`) is one CREATE2 deployment through Nick's factory
at **`0x99999923fAb5D50Df0F3b2F89a49d18EC82Bea79`**, with a total supply of **2²⁵⁶ − 1**, the largest
value the EVM can hold, minted at genesis to `bankon.eth`. Each chain was identified through
**chainmarketcap** (the allchainz API: chain id, name, native currency, public RPC endpoints), and each
endpoint had to answer `eth_chainId` with that chain before its reading counted.

| Chain (chainmarketcap) | Chain id | Endpoint | Block | Code | `decimals()` | `totalSupply()` |
|---|---|---|---|---|---|---|
| Ethereum Mainnet | 1 | ethereum-rpc.publicnode.com | 26,374,038 | 2,785 bytes | 18 | 2²⁵⁶ − 1 |
| OP Mainnet | 10 | mainnet.optimism.io | 159,294,442 | 2,785 bytes | 18 | 2²⁵⁶ − 1 |
| Base | 8453 | mainnet.base.org | 54,986,437 | 2,785 bytes | 18 | 2²⁵⁶ − 1 |
| Arbitrum One | 42161 | arb1.arbitrum.io | 522,531,274 | 2,785 bytes | 18 | 2²⁵⁶ − 1 |

The same code at the same address on every chain, and the same supply, to the last unit:

```
2²⁵⁶ − 1 = 115792089237316195423570985008687907853269984665640564039457584007913129639935 base units
         = 115792089237316195423570985008687907853269984665640564039457.584007913129639935 SCIEN·TIFIC
```

All 78 digits are held exactly. The deployment record: [scientific.pythai.net](https://scientific.pythai.net).

## 3. SHAMBA LUV: price and value from Uniswap (live)

LUV's price is created by its one liquidity pair, the Uniswap V2 pool **LUV/WETH**
[`0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31`](https://etherscan.io/address/0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31)
(token0 = LUV, token1 = WETH, both 18 decimals). Read by `getReserves()` at block **26,374,043**
(2026-11-09T01:28:35Z):

| | Exact reading |
|---|---|
| LUV in the pool | `1597428260395553.551626469790170421` LUV |
| WETH in the pool | `0.170436138195926065` WETH |
| ETH in LUV | `9372591266760683.264699906667718643` LUV per WETH |
| LUV in ETH (18 decimals) | `0.000000000000000106` WETH per LUV: three significant digits, so rule 5 applies |
| LUV in wei | `106.694079741473237002` wei per LUV (the seed was exactly 10 wei: ×`10.669407974147323700`) |
| ETH/USD | `2133.467716000102147123`, from the USDC/WETH pair [`0xB4e1…C9Dc`](https://etherscan.io/address/0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc) at the same block |
| 1,000,000,000,000 LUV | `$0.227628374616773675` |
| the pool, both sides | `$727.239996961480303923` |
| total supply | `111111111111111111.111111111111111111` LUV, a repunit to the last decimal |
| held by `0x…dEaD` | `4980559643425538.726831537253385007` LUV |

chronos.oracle's `pairprice` read the same pair at the same block independently and gave the same
reserves and the same two ratios, digit for digit (integer floor division; its Python twin agrees to
the 18th decimal).

**The standard, caught in our own data.** The live oracle's `market.json` publishes the total supply as
the JSON number `111111111111111100`: a double cannot hold the repunit, so its last digits are lost before
anyone reads them. The chain holds `111111111111111111.111111111111111111`. The fix the standard asks for
is to publish amounts as decimal strings with all 18 decimals, as every figure on this page is
(proposed for the collector).

## 4. Distribution: CPU and GPU contribution, paid in SHAMBA LUV (proposed)

bankonOSML, browseML's verified bankML engine with a contribution panel, lends a browser's CPU and GPU
to a host for inference, on the contributor's terms: separate CPU and GPU percentages, the contributor's
own question first, every visit starting unshared. What it contributes is measured, not estimated:

- **tokens written**, counted on each answer's receipt (the receipt's sha256 is checked);
- **core-seconds** (engine threads × engine time) and **GPU-seconds** (the card's verified share × time);
- all of it kept in the receipt ledger as 18-decimal integers, hash-chained (keccak256).

SHAMBA LUV is the distribution mechanism. The proposal extends the **IncentiveDistributor**
(shamba-luv/incentivedistributor):

1. **Measure.** Each epoch, the host totals every contributor's measured work in one unit of account,
   the **token-equivalent**: tokens written × rate, plus core-seconds × rate, plus GPU-seconds × rate,
   each rate published by the host as an 18-decimal integer.
2. **Price.** The token-equivalent is exchanged into the payout token at a price **chronos.oracle and
   kairos.agent set from measurement**: the payout token's liquidity pair, read at a stated block (the
   `time.moment`), by integer floor division. For LUV that is the LUV/WETH pair above; the same reading
   works for any Uniswap V2 or V3 pair (`chronos/src/pairprice`).
3. **Configurable token.** The payout token is a setting, not a constant: LUV by default, or any token
   with a liquidity pair chronos can read. The epoch records the token, the pair, the block, the price
   and the rates, so anyone can recompute every payout from the chain and the receipts.
4. **Distribute.** The epoch's payouts become a Merkle root committed to the IncentiveDistributor;
   each contributor claims their amount with a proof, in the payout token, with no float anywhere
   between the receipt and the claim.

What exists today: the receipts, the 18-decimal ledgers and the share controls (browseML, built); the
pair readings stamped by block (chronos.oracle, built); the IncentiveDistributor's corrected contracts
(built, private). What is proposed: the epoch accounting, the configurable payout token and the Merkle
claims in the IncentiveDistributor.
