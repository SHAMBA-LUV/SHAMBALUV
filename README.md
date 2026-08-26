# 🚀 <a href="https://luv.pythai.net">SHAMBA LUV</a> is priceless — and LIVE on Ethereum

> ✅ **LIVE STATUS — Ethereum mainnet.** LUV trades live on Uniswap; the price is created by the LUV/ETH
> pair, expressed on Uniswap, and measured by the oracle. **Phase 3 — The Price of LUV — is LIVE.**
> https://luv.pythai.net · [LIVE VIEW](https://luv.pythai.net/view.html) · [FAQ](https://luv.pythai.net/faq.html) · [the docs](https://luv.pythai.net/docs.html)

| | Ethereum mainnet (chain id 1) |
|---|---|
| **SHAMBA LUV token (`LUV`)** — verified ✅ | [`0x2711111111683B8708cb9a48cBf36a51315F8254`](https://etherscan.io/address/0x2711111111683B8708cb9a48cBf36a51315F8254#code) |
| **LUV / WETH pair (Uniswap V2)** | [`0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31`](https://etherscan.io/address/0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31) |
| **Liquidity lock (ownerless, extend-only)** | [`0x111111f70cb3469B5285862d7a4e7Cb53d04f502`](https://etherscan.io/address/0x111111f70cb3469B5285862d7a4e7Cb53d04f502) — 100% of circulating LP, [proof](https://luv.pythai.net/liqlock.html) |
| **Owner / deployer** | `bankon.eth` — `0x10f7Ee226B16bea7f365Dc1eDEF159Fc1957D169` |
| **Contract source** | [`contracts/ShambaLuv.sol`](contracts/ShambaLuv.sol) · complete guide: [`LUV.md`](LUV.md) |
| **Supply** | 111,111,111,111,111,111.111111111111111111 LUV — a repunit of ones, fixed at genesis, no mint |
| **Fees** | 5% on market trades, split **3 : 1 : 1** (3% reflections to holders · 1% liquidity · 1% team via 2-of-3 DAIO). **Wallet-to-wallet: no fee — 1 LUV === 1 LUV** |
| **Trade** | [Uniswap — USDC → LUV](https://app.uniswap.org/swap?chain=ethereum&inputCurrency=0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48&outputCurrency=0x2711111111683B8708cb9a48cBf36a51315F8254) (set slippage ≈ 10%: fee-on-transfer token) |

**Papers & guides:** [EMOTONOMICS](docs/EMOTONOMICS.md) · [firstLUV — your first LUV, and the key that holds it](docs/firstLUV.md) · [LUVPAPER](docs/LUVPAPER.md) · [the liquidity lock](docs/LIQLOCK.md) · on-site: [emotonomics](https://luv.pythai.net/emotonomics.html) · [the engine](https://luv.pythai.net/engine.html) · [sentiment](https://luv.pythai.net/sentiment.html) · [wei](https://luv.pythai.net/wei.html)

```txt
SHAMBA LUV is a digital gesture designed to spread abundance, fun, joy and LUV as community vibe for social sharing building an emotional economy where gestures are stored on-chain giving attention, gestures, and community impact value from the power of LUV
```

> ⚠️ **The Polygon test contract is ABANDONED.** The original `LUV8.sol` deployment on Polygon
> (`0x1035760d0f60B35B63660ac0774ef363eAa5456e`, with its test airdrop and MultiSend contracts) was a
> **test**. It is not the live token, it is not maintained, and nothing should be deployed from that
> template. LUV moved to **Ethereum** at the verified address above. The Polygon-era deployment guide is
> [defunct](docs/POLYGON_DEPLOYMENT_GUIDE.md) and archived privately. **The pioneers who held LUV on
> Polygon are honoured — the pioneers' LUVdrop, 1 LUV == 1 LUV** on the live Ethereum contract:
> see [the FAQ](https://luv.pythai.net/faq.html#polygon).

---

## 🗄️ Legacy deployment template (Polygon test era — archived, NOT the live contract)

Everything below this line documents the **abandoned Polygon test deployment** (`LUV8.sol`, QuickSwap
routers, Polygonscan verification). It is kept for transparency and history only. For the live Ethereum
contract use [`contracts/ShambaLuv.sol`](contracts/ShambaLuv.sol) and [`LUV.md`](LUV.md).

This folder contains a comprehensive deployment template for the gesture based SHAMBA LUV cryptosystem, including the main token contract and airdrop contract. This repo is provided to the blockchain community at large as a transparent guide to show the creation of LUV and the sharing of LUV to create emotonomic gesture based value. Share the LUV.<br />

## 📁 File Structure

```
deploy/
├── README.md                          # This documentation file
├── LUV8.sol                           # SHAMBA LUV token contract
├── LUV8_flattened.sol                 # SHAMBA LUV contract for verification
├── ShambaLuvAirdrop.sol               # Airdrop contract
├── ShambaLuvAirdrop_VERIFICATION.sol  # Airdrop contract for verification
├── deploy-live.sh                     # LUV8 token deployment script
├── deploy-airdrop.sh                  # Airdrop contract deployment script
├── verify_correct_version.sh          # SHAMBA LUV verification script
├── TECHNICAL.md SUMMARY.md            # Complete verification guide
├── AIRDROP_DEPLOYMENT_SUMMARY.md      # Complete airdrop deployment summary
└── [Generated Files]                  # Created during deployment
    ├── DeploymentDetails.md           # SHAMBA LUV deployment details
    ├── AirdropDeploy.md               # Airdrop deployment details
    ├── deploy/verify-contract.sh      # SHAMBA LUV verification script
    └── deploy/verify-airdrop.sh       # Airdrop verification script
```

## 🔧 Prerequisites

### Environment Variables (.env file)
```bash
# Wallet Configuration
TEAM_WALLET=0x2Ab888888004fEF6B6Fa020edFd067139266F67C
LIQUIDITY_WALLET=0x9E5e48aaE6D86c049053eeeD0a125C0f3635693F
PRIVATE_KEY=0xYourPrivateKey

# API Keys
ETHERSCAN_API_KEY=YourEtherscanApiKey

# Optional: LUV8 Contract Address (for airdrop deployment)
LUV_CONTRACT_ADDRESS=0x1035760d0f60B35B63660ac0774ef363eAa5456e
```

### Dependencies
- Foundry (forge, cast)
- OpenZeppelin Contracts (automatically installed)
- jq (for JSON parsing)

## 🎯 Deployment Scripts

### <a href="https://luv.pythai.net">SHAMBA LUV</a><br />
 Token Deployment (`deploy-live.sh`)

Deploys the main SHAMBA LUV token contract with reflection mechanism and holder protection.

**Usage:**
```bash
./deploy/deploy-live.sh
```

**Features:**
- ✅ Comprehensive validation
- ✅ Automatic constructor argument generation
- ✅ Deployment information documentation
- ✅ Verification script generation
- ✅ Error handling and troubleshooting

**Constructor Arguments:**
- Team Wallet Address
- Liquidity Wallet Address
- QuickSwap V2 Router Address

### <a href="https://luv.pythai.net">Airdrop**:</a> Contract Deployment (`deploy-airdrop.sh`)

Deploys the ShambaLuvAirdrop contract for flexible token distribution.

**Usage:**
```bash
# Interactive mode (prompts for token address)
./deploy/deploy-airdrop.sh

# With specific token address
./deploy/deploy-airdrop.sh 0x1035760d0f60B35B63660ac0774ef363eAa5456e
```

**Features:**
- ✅ Flexible airdrop for any ERC20 token
- ✅ One-time claim per address per token
- ✅ Emergency withdrawal functions
- ✅ Token rescue capabilities
- ✅ Comprehensive admin controls

**Constructor Arguments:**
- Default Token Address (for airdrops)

## 🔍 Verification Scripts

### Correct Version Verification (`verify_correct_version.sh`)

Verifies contracts using the exact settings that work for ShambaLuv

**Usage:**
```bash
# Interactive mode
./deploy/verify_correct_version.sh

# With contract address
./deploy/verify_correct_version.sh 0x1035760d0f60B35B63660ac0774ef363eAa5456e
```

**Confirmed Working Settings:**
- Compiler Version: `v0.8.30`
- Optimization: Enabled
- Optimizer Runs: 200
- Via IR: Enabled

### Generated Verification Scripts

During deployment, the following scripts are automatically generated:

- `verify-contract.sh` - For SHAMBA LUV token verification
- `verify-airdrop.sh` - For airdrop contract verification

## 📋 Contract Features

### SHAMBA LUV Token — Polygon test (`LUV8.sol`, abandoned)
- **Reflection Mechanism**: Automatic token distribution to holders
- **Liquidity Management**: Automatic liquidity provision
- **Security Features**: Timelock, slippage protection
- **Multi-Router Support**: V2 and V3 router compatibility
- **Gas Optimization**: Batch processing and efficient operations
- **Admin Controls**: Comprehensive admin functions
- **Emergency Functions**: Stuck balance recovery

### <a href="https://luv.pythai.net">ShambaLuvAirdrop</a> (`ShambaLuvAirdrop.sol`)
- **Flexible <a href="https://luv.pythai.net">Airdrop**:</a> Support for any ERC20 token
- **One-Time Claims**: Prevents double-claiming
- **Emergency Controls**: Withdrawal and rescue functions
- **Admin Management**: Configurable airdrop settings
- **Reentrancy Protection**: Secure token transfers
- **Multi-Token Support**: Multiple token configurations

## 🚀 Quick Start Guide

### Step 1: Prepare Environment
```bash
# Create .env file with required variables
cp .env.example .env
# Edit .env with your values
```

### Step 2: Deploy <a href="https://luv.pythai.net">SHAMBA LUV</a> Token
```bash
./deploy/deploy-live.sh
```

### Step 3: Deploy Airdrop Contract
```bash
# Use the LUV8 contract address from step 2
./deploy/deploy-airdrop.sh 0xYourLUV8ContractAddress
```

### Step 4: Verify Contracts
```bash
# Verify LUV token
./deploy/verify_correct_version.sh 0x1035760d0f60B35B63660ac0774ef363eAa5456e

# Verify airdrop contract
./deploy/verify_correct_version.sh 0x583F6D336E777c461FbfbeE3349D7D2dA9dc5e51
```

## 🔧 Manual Verification

### For PolygonScan Verification (legacy — the Polygon test contract is abandoned):

1. **Go to Contract Page**: [the abandoned Polygon test contract](https://polygonscan.com/token/0x1035760d0f60B35B63660ac0774ef363eAa5456e)
2. **Click "Contract" tab**
3. **Click "Verify and Publish"**
4. **Fill in the verification form**:
   - **Compiler Type**: Solidity (Single file)
   - **Compiler Version**: `v0.8.30`
   - **Open Source License Type**: MIT License
   - **Optimization**: **Enabled**
   - **Runs**: `200`
   - **Via IR**: **Enabled**
5. **Copy the entire content** of the appropriate `*_VERIFICATION.sol` file
6. **Constructor Arguments**: Use the ABI-encoded string from deployment
7. **Click "Verify and Publish"**

## 📊 Network Information

### Ethereum Mainnet — LIVE
- **Chain ID**: 1
- **Block Explorer**: https://etherscan.io
- **LUV (verified ✅)**: [`0x2711111111683B8708cb9a48cBf36a51315F8254`](https://etherscan.io/address/0x2711111111683B8708cb9a48cBf36a51315F8254#code)
- **Uniswap V2 pair (LUV/WETH)**: [`0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31`](https://etherscan.io/address/0x57D2085Aa859a145cB107845AD03c0eAAFBD8a31)
- **Live market**: https://luv.pythai.net/view.html · machine-readable: https://luv.pythai.net/market.json

### Polygon Mainnet — ABANDONED (test contract)
- **Chain ID**: 137
- **RPC URL**: https://polygon-rpc.com
- **Block Explorer**: https://polygonscan.com
- **<a href="https://polygonscan.com/address/0xa5e0829caced8ffdd4de3c43696c57f7d7a678ff">QuickSwap V2 Router**</a>: `0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff`
- **<a href="https://polygonscan.com/address/0xf5b509bb0909a69b1c207e495f687a596c168e12#code">QuickSwap V3 Router**</a>: `0xf5b509bB0909a69B1C207E495f687a6C0Ee0989e`

## 🔍 Troubleshooting

### Common Issues:

1. **"Unable to find matching Contract Bytecode and ABI"**
   - Use compiler version `v0.8.30` (not v0.8.23)
   - Ensure via-ir is enabled
   - Verify optimization settings (enabled, 200 runs)
   - Use the exact flattened source code

2. **Constructor Arguments Error**
   - Ensure ABI encoding is correct
   - Check wallet addresses are valid
   - Verify router address is correct

3. **Dependency Issues**
   - Run `forge install` to install dependencies
   - Check remappings in `foundry.toml`
   - Ensure OpenZeppelin contracts are installed

4. **Verification Script Issues**
   - Check API key is valid
   - Ensure contract is deployed on correct network
   - Verify contract address is correct

## 📈 Post-Deployment Steps

### Dev For Airdrop Contract:
1. Deposit tokens to airdrop contract
2. Configure airdrop amounts
3. Test airdrop functionality
4. Set up distribution strategy
5. Monitor airdrop claims

## Participant for Airdrop Contract
<a href="https://luv.pythai.net">SHAMBA LUV</a>

## 📋 Deployment Documentation

### AIRDROP_DEPLOYMENT_SUMMARY.md
Complete documentation of the ShambaLuvAirdrop deployment including:
- ✅ Contract deployment details and addresses
- ✅ Verification settings and status
- ✅ Block explorer links
- ✅ Contract features and functionality
- ✅ Integration with SHAMBA LUV ecosystem
- ✅ Technical specifications
- ✅ Next steps and recommendations
- ✅ Useful commands for contract interaction

**Location**: `deploy/AIRDROP_DEPLOYMENT_SUMMARY.md`

## 🔗 Useful Commands

### Check Contract Status
```bash
# Check if contract is verified
curl "https://api.polygonscan.com/api?module=contract&action=getabi&address=YOUR_CONTRACT_ADDRESS&apikey=YOUR_API_KEY"
```

### Generate Constructor Arguments
```bash
# SHAMBA LUV
cast abi-encode "constructor(address,address,address)" "TEAM_WALLET" "LIQUIDITY_WALLET" "ROUTER_ADDRESS"

# For airdrop contract
cast abi-encode "constructor(address)" "TOKEN_ADDRESS"
```

### Check Contract Balance
```bash
# Check token balance
cast balance "CONTRACT_ADDRESS" --rpc-url "https://polygon-rpc.com"
```

## 📞 Support
luv@pythai.net

## 📄 License

This deployment template is provided as-is for personal educational and development purposes to further global abundance and joy as a social standard. Use at your own risk and ensure proper testing before mainnet deployment. LUV is a gesture.

---

**<a href="https://luv.pythai.net">SHAMBA LUV</a>**: 1.0  
**Last Updated**: $(date)  
**Verified Contracts**: ✅ <a href="https://luv.pythai.net">SHAMBA LUV</a><br />
 Token, ✅ ShambaLuvAirdrop<br /><br />

 <a href="https://youtu.be/dcRR__y1SYM?si=ECzDmJNbdgAoAaYH">Attract True Wealth | Alan Watts</a>
