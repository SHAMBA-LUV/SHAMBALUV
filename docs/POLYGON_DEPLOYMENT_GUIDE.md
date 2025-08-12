# ShambaLuv Token (LUV.sol) - Polygon Mainnet Deployment Guide
This is how we do it... with LUV from the SHAMBA LUV community

## Overview

This guide provides step-by-step instructions for deploying the ShambaLuv token (LUV8.sol) to Polygon mainnet. The contract is production-ready and includes advanced features like reflection distribution, wallet-to-wallet fee exemption, and comprehensive security measures.

## Contract Features

### Core Features
- **Total Supply**: 100 Quadrillion LUV tokens
- **Fee Structure**: 5% total fees
  - 3% Reflection Fee (distributed to holders)
  - 1% Liquidity Fee (for liquidity pools)
  - 1% Team Fee (for marketing and development)
- **Wallet-to-Wallet Transfers**: Fee-free transfers between EOAs
- **Gas Optimization**: Batch reflection processing for efficiency
- **Security**: Slippage protection, timelock mechanisms, emergency functions

### Advanced Features
- **Multi-Router Support**: QuickSwap V2 and V3 router compatibility
- **Reflection System**: Automatic distribution of fees to token holders
- **Max Transfer Protection**: Configurable transfer limits
- **Emergency Recovery**: Functions to rescue stuck tokens and ETH
- **Admin Management**: Secure admin role management

## Prerequisites
### Required Software
- [Foundry](https://getfoundry.sh/) (latest version)
- [Git](https://git-scm.com/)
- A text editor (VS Code recommended)

### Required Accounts
- **Deployer Wallet**: Must have sufficient MATIC for gas fees
- **Team Wallet**: Address to receive team fees
- **Liquidity Wallet**: Address to receive liquidity fees
- **Polygonscan API Key**: For contract verification

### Required MATIC
- **Deployment**: ~0.1-0.5 MATIC (depending on gas prices)
- **Verification**: ~0.05-0.1 MATIC
- **Liquidity Setup**: Variable (depends on liquidity amount)

## Step 1: Environment Setup

### 1.1 Clone and Setup Repository
```bash
git clone <repository-url>
cd LUVcontract
forge install
```

### 1.2 Configure Environment Variables
```bash
cp env.example .env
```

Edit the `.env` file with your configuration:

```bash
# Private Key (DO NOT SHARE OR COMMIT THIS FILE)
PRIVATE_KEY=your_private_key_here_without_0x_prefix

# Deployment Addresses
TEAM_WALLET=0xYourTeamWalletAddress
LIQUIDITY_WALLET=0xYourLiquidityWalletAddress

# Router Address (Polygon Mainnet)
ROUTER_ADDRESS=0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff

# RPC URL (Polygon Mainnet)
POLYGON_RPC_URL=https://polygon-rpc.com

# Etherscan API Key (for verification)
ETHERSCAN_API_KEY=your_etherscan_api_key_here

# Gas Settings (optional)
GAS_LIMIT=5000000
GAS_PRICE=30000000000
```

### 1.3 Validate Configuration
```bash
./deploy-luv8.sh
```

The script will validate your configuration and show deployment details.

## Step 2: Deployment

### 2.1 Run Deployment Script
```bash
./deploy-luv8.sh
```

The script will:
1. Validate environment variables
2. Build the contracts
3. Deploy the ShambaLuv token
4. Verify the deployment
5. Save deployment information to `deployment-info.txt`

### 2.2 Verify Deployment
After deployment, verify the contract on Polygonscan:
1. Go to [Polygonscan](https://polygonscan.com/)
2. Search for your contract address
3. Verify the contract source code
4. Check that all functions are working correctly

## Step 3: Post-Deployment Configuration

### 3.1 Set Up Admin Wallet (Recommended)
```bash
# Using Foundry console
forge console --rpc-url $POLYGON_RPC_URL

# Set admin wallet
cast send <CONTRACT_ADDRESS> "setAdmin(address)" <ADMIN_WALLET_ADDRESS> --private-key $PRIVATE_KEY
```

### 3.2 Configure QuickSwap V3 (Optional)
```bash
# Enable QuickSwap V3 router
forge script script/DeployLUV8.s.sol:DeployLUV8 --sig 'runWithQuickSwapV3()' --rpc-url $POLYGON_RPC_URL --broadcast
```

### 3.3 Test Core Functions
```bash
# Test wallet-to-wallet transfer
cast send <CONTRACT_ADDRESS> "transfer(address,uint256)" <RECIPIENT_ADDRESS> <AMOUNT> --private-key $PRIVATE_KEY

# Test reflection claim
cast send <CONTRACT_ADDRESS> "claimReflections()" --private-key $PRIVATE_KEY
```

## Step 4: Liquidity Setup

### 4.1 QuickSwap V2 Liquidity
1. Go to [QuickSwap](https://quickswap.exchange/)
2. Connect your wallet
3. Navigate to "Pool" → "Add Liquidity"
4. Add LUV/MATIC pair
5. Set initial liquidity amount

### 4.2 QuickSwap V3 Liquidity (Optional)
1. Go to [QuickSwap V3](https://v3.quickswap.exchange/)
2. Connect your wallet
3. Add concentrated liquidity for LUV/MATIC pair

## Step 5: Testing and Verification

### 5.1 Test Reflection System
1. Make a small trade on QuickSwap
2. Check if reflection fees are distributed
3. Verify wallet-to-wallet transfers are fee-free

### 5.2 Test Security Features
1. Test max transfer limits
2. Verify slippage protection
3. Test emergency functions

### 5.3 Monitor Contract
1. Set up monitoring for reflection distribution
2. Monitor gas usage and optimization
3. Track fee collection and distribution

## Contract Addresses

### Polygon Mainnet
- **QuickSwap V2 Router**: `0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff`
- **QuickSwap V3 Router**: `0xF5B509Bb0909A69B1c207e495F687a6C0eE0989e`
- **Wrapped MATIC (WPOL)**: `0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270`

## Security Considerations

### Private Key Security
- Never commit your `.env` file
- Use hardware wallets for production deployments
- Consider using a dedicated deployment wallet

### Contract Security
- The contract includes comprehensive security features
- Timelock mechanisms protect critical functions
- Emergency functions allow recovery of stuck funds
- Slippage protection prevents MEV attacks

### Post-Deployment Security
- Consider renouncing ownership after setup
- Set up admin wallet for ongoing management
- Monitor contract activity regularly

## Troubleshooting

### Common Issues

#### Deployment Fails
- Check MATIC balance for gas fees
- Verify private key format (no 0x prefix)
- Ensure RPC URL is correct and accessible

#### Verification Fails
- Check Etherscan API key
- Ensure contract compilation is successful
- Verify constructor parameters match deployment

#### Reflection Not Working
- Check if wallet is excluded from reflections
- Verify reflection threshold settings
- Ensure sufficient trading volume for reflection distribution

### Support
- Check deployment logs in `deployment-info.txt`
- Review contract events on Polygonscan
- Test functions using Foundry console

## Advanced Configuration

### Custom Router Setup
```bash
# Deploy with custom router
forge script script/DeployLUV8.s.sol:DeployLUV8 --sig 'runWithCustomRouter(address)' <CUSTOM_ROUTER_ADDRESS> --rpc-url $POLYGON_RPC_URL --broadcast
```

### Gas Optimization
The contract includes several gas optimization features:
- Batch reflection processing
- Local total supply tracking
- Optimized storage patterns
- Efficient event emission

### Monitoring Setup
Consider setting up monitoring for:
- Reflection distribution events
- Fee collection statistics
- Gas usage optimization
- Security event monitoring

## Conclusion

The ShambaLuv token (LUV8.sol) is now deployed and ready for production use on Polygon mainnet. The contract includes advanced features for reflection distribution, security, and gas optimization.

Remember to:
1. ✅ Verify the contract on Polygonscan
2. ✅ Set up liquidity pools
3. ✅ Test all core functions
4. ✅ Configure admin wallet
5. ✅ Monitor contract activity
6. ✅ Set up proper security measures

For additional support or questions, refer to the contract documentation and test files included in the repository. 
