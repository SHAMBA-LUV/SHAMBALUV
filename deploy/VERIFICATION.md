# LUV8 Contract Verification Guide

## ✅ VERIFIED CONTRACT INFORMATION

### Current Verified Contract
- **Contract Address**: `0x1035760d0f60b35b63660ac0774ef363eaa5456e`
- **Contract Name**: `ShambaLuv`
- **Network**: Polygon Mainnet
- **Status**: ✅ **VERIFIED**
- **Block Explorer**: https://polygonscan.com/address/0x1035760d0f60b35b63660ac0774ef363eaa5456e

### Verification Details
- **Compiler Version**: `v0.8.30`
- **Optimization**: Enabled
- **Optimizer Runs**: 200
- **Via IR**: Enabled
- **Source File**: `deploy/LUV8_VERIFICATION.sol`

### Constructor Arguments
```
0x0000000000000000000000002ab888888004fef6b6fa020edfd067139266f67c0000000000000000000000009e5e48aae6d86c049053eeed0a125c0f3635693f000000000000000000000000a5e0829caced8ffdd4de3c43696c57f7d7a678ff
```

### Wallet Addresses Used
- **Team Wallet**: `0x2Ab888888004fEF6B6Fa020edFd067139266F67C`
- **Liquidity Wallet**: `0x9E5e48aaE6D86c049053eeeD0a125C0f3635693F`
- **Router Address**: `0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff` (QuickSwap V2)

## 🚀 Template for Future Projects

### Step 1: Prepare Environment
```bash
# Create .env file with required variables
TEAM_WALLET=0xYourTeamWalletAddress
LIQUIDITY_WALLET=0xYourLiquidityWalletAddress
PRIVATE_KEY=0xYourPrivateKey
ETHERSCAN_API_KEY=YourEtherscanApiKey
```

### Step 2: Deploy Contract
```bash
# Run deployment script
./deploy/deploy-live.sh
```

### Step 3: Verify Contract
```bash
# Run verification script
./deploy/verify-contract.sh
```

## 📋 Manual Verification Process

### For PolygonScan Verification:

1. **Go to Contract Page**: https://polygonscan.com/address/YOUR_CONTRACT_ADDRESS

2. **Click "Contract" tab**

3. **Click "Verify and Publish"**

4. **Fill in the verification form**:
   - **Compiler Type**: Solidity (Single file)
   - **Compiler Version**: `v0.8.30`
   - **Open Source License Type**: MIT License
   - **Optimization**: **Enabled**
   - **Runs**: `200`
   - **Via IR**: **Enabled**

5. **Copy the entire content** of `deploy/LUV8_VERIFICATION.sol` and paste it into the "Contract Source Code" field

6. **Constructor Arguments**: Use the ABI-encoded string from deployment

7. **Click "Verify and Publish"**

## 🔧 Automated Verification Script

```bash
#!/bin/bash

# Load environment variables
source .env

# Contract details
CONTRACT_ADDRESS="YOUR_CONTRACT_ADDRESS"
CONSTRUCTOR_ARGS="YOUR_ABI_ENCODED_CONSTRUCTOR_ARGS"

echo "🔧 Verifying Contract on PolygonScan"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Constructor Args: $CONSTRUCTOR_ARGS"
echo "=================================================="

forge verify-contract \
    "$CONTRACT_ADDRESS" \
    deploy/LUV8_VERIFICATION.sol:ShambaLuv \
    --chain-id 137 \
    --etherscan-api-key "$ETHERSCAN_API_KEY" \
    --constructor-args "$CONSTRUCTOR_ARGS" \
    --compiler-version "v0.8.30" \
    --optimizer-runs 200 \
    --via-ir
```

## 🎯 Key Points for Success

1. **Use `deploy/LUV8_VERIFICATION.sol`** - This is the flattened file that generates the correct bytecode
2. **Compiler Version**: `v0.8.30` (not v0.8.23 as initially reported by PolygonScan)
3. **Via IR**: Must be enabled
4. **Optimization**: Must be enabled with 200 runs
5. **Constructor Arguments**: Use the exact ABI-encoded string provided

## 📁 Required Files

### For Deployment:
- `deploy/LUV8.sol` - Main contract file
- `deploy/deploy-live.sh` - Deployment script
- `.env` - Environment variables

### For Verification:
- `deploy/LUV8_VERIFICATION.sol` - Flattened contract for verification
- `deploy/verify-contract.sh` - Verification script
- `ETHERSCAN_API_KEY` in `.env`

## 🔍 Troubleshooting

### Common Issues:

1. **"Unable to find matching Contract Bytecode and ABI"**
   - Check compiler version is `v0.8.30`
   - Ensure via-ir is enabled
   - Verify optimization settings (enabled, 200 runs)
   - Use the exact flattened source code

2. **Constructor Arguments Error**
   - Ensure ABI encoding is correct
   - Check wallet addresses are valid
   - Verify router address is correct

3. **Compiler Version Issues**
   - Use `v0.8.30` for best compatibility
   - Avoid using `v0.8.23` as it may cause bytecode mismatches

## 📊 Contract Features

### LUV8 Token Features:
- **Reflection Mechanism**: Automatic token distribution to holders
- **Liquidity Management**: Automatic liquidity provision
- **Security Features**: Timelock, slippage protection
- **Multi-Router Support**: V2 and V3 router compatibility
- **Gas Optimization**: Batch processing and efficient operations
- **Admin Controls**: Comprehensive admin functions
- **Emergency Functions**: Stuck balance recovery

### Token Information:
- **Name**: SHAMBA LUV
- **Symbol**: LUV
- **Decimals**: 18
- **Total Supply**: 1,000,000,000 LUV
- **Network**: Polygon Mainnet

## 🚀 Ready for Production

The LUV8 contract is now verified and ready for production use. The deployment template provides a complete framework for future token deployments with similar features.

### Next Steps for New Projects:
1. Customize contract parameters
2. Update wallet addresses
3. Deploy using the template
4. Verify using the provided scripts
5. Test all contract functions
6. Add liquidity to DEX

---

**Template Version**: 1.0  
**Last Updated**: $(date)  
**Verified Contract**: ✅ `0x1035760d0f60b35b63660ac0774ef363eaa5456e` 
