# The pioneers' LUVdrop: Polygon holders, 1 LUV == 1 LUV on Ethereum

The holders of the Polygon original ([`0x1035760d0f60B35B63660ac0774ef363eAa5456e`](https://polygonscan.com/token/0x1035760d0f60B35B63660ac0774ef363eAa5456e),
the abandoned test contract) are honoured on the live Ethereum token
([`0x2711111111683B8708cb9a48cBf36a51315F8254`](https://etherscan.io/token/0x2711111111683B8708cb9a48cBf36a51315F8254)) one to one.
This folder is the reference list and the live check of that drop, kept to the
[SCIEN·TIFIC standard of accuracy](../docs/ACCURACY.md): every balance is an integer of 10⁻¹⁸ read at a stated block.

| Mark | Meaning |
|---|---|
| ✅ verified | the Ethereum recipient holds at least the 1:1 equivalent of its Polygon seats |
| 🟠 warning | not delivered yet, partly delivered, above the 1T LUV cohort ceiling, no recipient, or the list incomplete |
| ❌ fail | the Polygon balance no longer equals the list (it would pay a wrong amount), or a balance could not be read |

## The check of 2026-11-09

Polygon block **96,988,358** (2026-11-09T01:33:13.000Z, polygon-bor-rpc.publicnode.com) · Ethereum block **26,374,073** (ethereum-rpc.publicnode.com).

**✅ 0 · 🟠 54 · ❌ 0** of 54 holders (41 cohort seats at or below 1T LUV, 37 Ethereum recipients).

- ❌ **none**: every amount in the August delivery list still equals Polygon, to the last of 18 decimals.
- 🟠 **the drop is not sent yet**: each of the 41 cohort recipients holds 0 LUV on Ethereum. When LUV is sent, `node luvdrop/check.mjs` turns each delivered seat ✅.
- 🟠 **13 holders are above the 1T LUV cohort ceiling** (the cohort doctrine of 2026-08-08: "trillionaire holders and below"); whether they are dropped is a decision, not a default.
- 🟠 **the list is not complete**: the listed balances add up to 93540724217567216.000000000000000000 of the total supply of 100000000000000000.000000000000000000 LUV; **6459275782432784.000000000000000000 LUV** is held by addresses this list does not name. Polygon's Blockscout now answers scripts with a browser challenge and the free RPCs refuse the full Transfer history, so finding them needs a Polygonscan (Etherscan v2) API key or an archive node. Until then, this list must not be called the whole of the Polygon holdings.

## Files

| File | What |
|---|---|
| [`polygon-holders-96988358.json`](polygon-holders-96988358.json) | every listed holder's `balanceOf` and code at Polygon block 96,988,358, exact |
| [`polygon-holders-96988358.csv`](polygon-holders-96988358.csv) | the same, with the cohort flag and the Ethereum recipient |
| [`delivery-map.json`](delivery-map.json) | Polygon seat → Ethereum recipient (a smart account delivers to its admin EOA) |
| [`check.mjs`](check.mjs) | re-reads both chains and prints every seat in green ✅, Bitcoin orange 🟠 or red ❌; zero dependencies, sends nothing |
| [`check-2026-11-09.json`](check-2026-11-09.json) | this check's record |

## Every seat

| | Polygon holder | LUV on Polygon | Kind | Ethereum recipient | Note |
|---|---|---|---|---|---|
| 🟠 | `0x9e5e48aae6d86c049053eeed0a125c0f3635693f` | 76000000000000000.000000000000000000 | EOA | `0x9e5e48aae6d86c049053eeed0a125c0f3635693f` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x2000005b9a3766609ed0f5c1c14ffe7b7b3d80d4` | 3000000000000000.000000000000000000 | EOA | `0x2000005b9a3766609ed0f5c1c14ffe7b7b3d80d4` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x7777701a3f4e7bb15e8dd7cbf9f2be1a58b1592c` | 3000000000000000.000000000000000000 | EOA | `0x7777701a3f4e7bb15e8dd7cbf9f2be1a58b1592c` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0xf41258a7ae0d123b803bc90eb33449824a700000` | 3000000000000000.000000000000000000 | EOA | `0xf41258a7ae0d123b803bc90eb33449824a700000` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x4f87fed88d1d48da0434db3e533722fed988888d` | 2147949999999900.000000000000000000 | EOA | `0x4f87fed88d1d48da0434db3e533722fed988888d` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x33336913a6f376ba532ed85c133b7210d7ab5f1b` | 1989000000000000.000000000000000000 | EOA | `0x33336913a6f376ba532ed85c133b7210d7ab5f1b` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x900b85d9f19759907c3c2ed16cbf8402bfb33333` | 1355843626584975.000000000000000000 | EOA | `0x900b85d9f19759907c3c2ed16cbf8402bfb33333` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0xad5e65bc04a63c846b51e946b5c775b015595985` | 1000000000000000.000000000000000000 | EOA | `0xad5e65bc04a63c846b51e946b5c775b015595985` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x583f6d336e777c461fbfbee3349d7d2da9dc5e51` | 799000000000000.000000000000000000 | contract | — | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x4891a01b6d052dcaee9c04b8eb18741298e2b171` | 670435865347776.000000000000000000 | EOA | `0x4891a01b6d052dcaee9c04b8eb18741298e2b171` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0xb1da3900d385c22b15407080b9e05a13b92d09b0` | 525244775634565.000000000000000000 | EOA | `0xb1da3900d385c22b15407080b9e05a13b92d09b0` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0xc15b4b925db1ac6c264634a2e4dc28f62296ee48` | 10450000000000.000000000000000000 | contract | — | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0xc1d3b936117349234aed85a86790ad8df199aa34` | 2000000000000.000000000000000000 | EOA | `0xc1d3b936117349234aed85a86790ad8df199aa34` | above the 1T LUV cohort ceiling: not in the drop by the cohort doctrine (decision needed) |
| 🟠 | `0x003813340d3dd8fc70551ebbdce6fb4fca15f301` | 1000000000000.000000000000000000 | contract | `0x3795bc787e012c04ad75f9d84ff1ca57ab19da7e` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x027ef238f661e89582121264292b4335ad00cd40` | 1000000000000.000000000000000000 | EOA | `0x027ef238f661e89582121264292b4335ad00cd40` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x03c308932c8ae212be66279b561772360032c093` | 1000000000000.000000000000000000 | EOA | `0x03c308932c8ae212be66279b561772360032c093` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x0b2c4a24dcf7ae1b5e8bd20a2f894323322c822d` | 1000000000000.000000000000000000 | contract | `0x73cb10576ff1533e8e2df7fec493fb0897e405de` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x135ab53215a9f15546a3fcec4569ad2042b16970` | 1000000000000.000000000000000000 | EOA | `0x135ab53215a9f15546a3fcec4569ad2042b16970` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x162130eb92d07af0e4d2d32a0aa56e2d464f2791` | 1000000000000.000000000000000000 | contract | `0x166a403f6b44a82cf97aaff3e12ad10fccaa1d98` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x186a62452ffd7992ca582b379bc5012cb017c45c` | 1000000000000.000000000000000000 | contract | `0xd564cd40e15cc64a92a84c37034918ba5c38ae5b` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x26ce4e4b429f8fc293c97b4e5f7c000e3ec2165b` | 1000000000000.000000000000000000 | EOA | `0x26ce4e4b429f8fc293c97b4e5f7c000e3ec2165b` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x281fea94007ae19c55da38c00cfaefc4faaf7a34` | 1000000000000.000000000000000000 | EOA | `0x281fea94007ae19c55da38c00cfaefc4faaf7a34` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x2df0f411ca2c43bd04cc0070d765565624edcb98` | 1000000000000.000000000000000000 | EOA | `0x2df0f411ca2c43bd04cc0070d765565624edcb98` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x473a8ea11cc64585dba70d440886084c7b5e6903` | 1000000000000.000000000000000000 | contract | `0xd1df46f0bb4faed71e6c2a814e94bab35a0fead2` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x5049e168871d116d86dba06b523005eaf5821c75` | 1000000000000.000000000000000000 | EOA | `0x5049e168871d116d86dba06b523005eaf5821c75` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x5ffb6db456b0ad35547a0316edcf0f1b4463e611` | 1000000000000.000000000000000000 | EOA | `0x5ffb6db456b0ad35547a0316edcf0f1b4463e611` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x63213c8d2e75be6b6ceb8e036a966bc1cdf083e8` | 1000000000000.000000000000000000 | contract | `0x814c0ad2b3d56ee7c771deb0c61d0561862861ab` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x668e91490d3ba4c9d58fa8a31ab4d3101e5b1103` | 1000000000000.000000000000000000 | contract | `0xc624b85812b9721048d33fff41c696f1e767c2f3` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x71c7656ec7ab88b098defb751b7401b5f6d8976f` | 1000000000000.000000000000000000 | EOA | `0x71c7656ec7ab88b098defb751b7401b5f6d8976f` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x7222a1605af43ad6a4df37574cf8be9bc8450d4e` | 1000000000000.000000000000000000 | EOA | `0x7222a1605af43ad6a4df37574cf8be9bc8450d4e` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x792f933dfb59f69aba0ceb643eedf79b6565c50c` | 1000000000000.000000000000000000 | EOA | `0x792f933dfb59f69aba0ceb643eedf79b6565c50c` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x87f307a8c4ead06bb303596314454f0607f2431c` | 1000000000000.000000000000000000 | EOA | `0x87f307a8c4ead06bb303596314454f0607f2431c` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x8956015cc678f97585c76fbdd2938e9b8842acfa` | 1000000000000.000000000000000000 | EOA | `0x8956015cc678f97585c76fbdd2938e9b8842acfa` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x8a07bf7eea05a754813358843e6f7856d7f081d1` | 1000000000000.000000000000000000 | EOA | `0x8a07bf7eea05a754813358843e6f7856d7f081d1` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x8ad742e567f5c0bf93c1aa2905f8a11b937eb0a1` | 1000000000000.000000000000000000 | contract | `0x87a1aa08906ec8ae8bf3ddd187faaa6addfcba0b` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x944be51a3709c58ada26d416891ac4f77abc9e4b` | 1000000000000.000000000000000000 | contract | `0x8a07bf7eea05a754813358843e6f7856d7f081d1` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x9a864aab3b5cc40529e9dac1d50459ca18208c54` | 1000000000000.000000000000000000 | EOA | `0x9a864aab3b5cc40529e9dac1d50459ca18208c54` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x9f914499e1e0ec442e734e2f093a25950dd4a8c5` | 1000000000000.000000000000000000 | EOA | `0x9f914499e1e0ec442e734e2f093a25950dd4a8c5` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xa737143a3752b44efa60475188d2adaaa4cd9759` | 1000000000000.000000000000000000 | EOA | `0xa737143a3752b44efa60475188d2adaaa4cd9759` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xaa2a97c7d650a3d4cc28f000e503ddc5be375d5a` | 1000000000000.000000000000000000 | contract | `0x6156d4a17d094bee5d453795ee3004a6dfb6c084` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xb580e27aa9bd9da0a9abf13d78d1c3a9af1863ef` | 1000000000000.000000000000000000 | EOA | `0xb580e27aa9bd9da0a9abf13d78d1c3a9af1863ef` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xb6691f6953f62cf008169e80d84b8d34cf3e4c7b` | 1000000000000.000000000000000000 | contract | `0xd319cd000df3a87be14bee43897169625a952ee9` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xbdf173a2ca391f4d6d2c5eb662158365c4889a73` | 1000000000000.000000000000000000 | contract | `0xb45fe7ee7346fbd55bb55f35153bb7e3ec431bdd` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xc4cce5afe8cd9cd2e2860c43ac2c9b77f4e20871` | 1000000000000.000000000000000000 | contract | `0x9f914499e1e0ec442e734e2f093a25950dd4a8c5` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xc82108a669e185ec5b48e64af4852b485da5a05f` | 1000000000000.000000000000000000 | EOA | `0xc82108a669e185ec5b48e64af4852b485da5a05f` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xcc4aa16be9cf5dfa3041dd6e6289b073d820a461` | 1000000000000.000000000000000000 | contract | `0x72c8bec19ae6fe3f1c23344332447f5a7f68486e` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xd3357904d822bdafaaea2ed8e8969de0bd407b84` | 1000000000000.000000000000000000 | EOA | `0xd3357904d822bdafaaea2ed8e8969de0bd407b84` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xd564cd40e15cc64a92a84c37034918ba5c38ae5b` | 1000000000000.000000000000000000 | EOA | `0xd564cd40e15cc64a92a84c37034918ba5c38ae5b` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xff0496549165d10b00095995a8254caea64c731a` | 1000000000000.000000000000000000 | contract | `0x1b435cfc25e8da4201ed1b53064bad937ad85c5a` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x9797fbb4508e944e2a527ab45aacc55d426880c0` | 999000000000.000000000000000000 | contract | `0x8242c67a8452de042b8e10f43d32ff7aeac1d9e5` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xb45fe7ee7346fbd55bb55f35153bb7e3ec431bdd` | 950950000000.000000000000000000 | EOA | `0xb45fe7ee7346fbd55bb55f35153bb7e3ec431bdd` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x2f3d1a8b77725762a27d54cf18f4df21708fd057` | 950000000000.000000000000000000 | EOA | `0x2f3d1a8b77725762a27d54cf18f4df21708fd057` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0x9e9177a5989045edfbd3951acd885df2020a9673` | 950000000000.000000000000000000 | EOA | `0x9e9177a5989045edfbd3951acd885df2020a9673` | not delivered yet (holds 0 LUV on Ethereum) |
| 🟠 | `0xe08b8a813ecf8d911f7ebf378b135e641629ac07` | 950000000000.000000000000000000 | EOA | `0xe08b8a813ecf8d911f7ebf378b135e641629ac07` | not delivered yet (holds 0 LUV on Ethereum) |
