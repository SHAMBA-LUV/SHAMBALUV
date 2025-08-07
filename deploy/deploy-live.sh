#!/bin/bash

# =============================================================================
# LUV8 Token Deployment Script Template
# =============================================================================
# This script provides a template for deploying ERC20 tokens with advanced features
# including reflection mechanism, liquidity management, and security features.
# 
# Features:
# - Reflection mechanism for automatic token distribution
# - Liquidity management and swap functionality
# - Timelock and security features
# - Multi-router support (V2 and V3)
# - Gas optimization and batch processing
# =============================================================================

set -e

# =============================================================================
# CONFIGURATION
# =============================================================================

# Load environment variables
if [ -f .env ]; then
    source .env
    echo "✅ .env file loaded"
else
    echo "❌ .env file not found!"
    echo "Please create .env file with required variables"
    exit 1
fi

# Contract configuration
CONTRACT_NAME="ShambaLuv"
CONTRACT_FILE="deploy/LUV8.sol"
VERIFICATION_FILE="deploy/LUV8_VERIFICATION.sol"

# Network configuration
NETWORK_ID=137  # Polygon Mainnet
CHAIN_ID=137
RPC_URL="https://polygon-rpc.com"

# Router addresses (Polygon)
QUICKSWAP_V2_ROUTER="0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff"
QUICKSWAP_V3_ROUTER="0xf5b509bB0909a69B1C207E495f687a6C0Ee0989e"

# =============================================================================
# VALIDATION
# =============================================================================

echo "🔍 Validating deployment configuration..."

# Check required environment variables
if [ -z "$TEAM_WALLET" ]; then
    echo "❌ TEAM_WALLET not set in .env file"
    exit 1
fi

if [ -z "$LIQUIDITY_WALLET" ]; then
    echo "❌ LIQUIDITY_WALLET not set in .env file"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ PRIVATE_KEY not set in .env file"
    exit 1
fi

# Validate wallet addresses
if [[ ! "$TEAM_WALLET" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "❌ Invalid TEAM_WALLET address format"
    exit 1
fi

if [[ ! "$LIQUIDITY_WALLET" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "❌ Invalid LIQUIDITY_WALLET address format"
    exit 1
fi

# Check if contract files exist
if [ ! -f "$CONTRACT_FILE" ]; then
    echo "❌ Contract file not found: $CONTRACT_FILE"
    exit 1
fi

if [ ! -f "$VERIFICATION_FILE" ]; then
    echo "❌ Verification file not found: $VERIFICATION_FILE"
    exit 1
fi

echo "✅ Configuration validation passed"

# =============================================================================
# DEPLOYMENT INFORMATION
# =============================================================================

echo ""
echo "🚀 LUV8 Token Deployment"
echo "================================"
echo "Network: Polygon Mainnet"
echo "Contract: $CONTRACT_NAME"
echo "Team Wallet: $TEAM_WALLET"
echo "Liquidity Wallet: $LIQUIDITY_WALLET"
echo "Router: $QUICKSWAP_V2_ROUTER"
echo "Chain ID: $CHAIN_ID"
echo ""

# =============================================================================
# CONFIRMATION
# =============================================================================

read -p "Do you want to proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 1
fi

echo ""
echo "🔧 Starting deployment process..."

# =============================================================================
# BUILD CONTRACTS
# =============================================================================

echo "📦 Building contracts..."
forge build --force

if [ $? -ne 0 ]; then
    echo "❌ Contract build failed"
    exit 1
fi

echo "✅ Contracts built successfully"

# =============================================================================
# DEPLOY CONTRACT
# =============================================================================

echo ""
echo "🚀 Deploying contract..."

# Deploy the contract
DEPLOY_OUTPUT=$(forge create \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --chain-id "$CHAIN_ID" \
    "$CONTRACT_FILE:$CONTRACT_NAME" \
    --constructor-args "$TEAM_WALLET" "$LIQUIDITY_WALLET" "$QUICKSWAP_V2_ROUTER")

# Extract contract address
CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -o "Deployed to: 0x[a-fA-F0-9]*" | cut -d' ' -f3)

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Failed to extract contract address from deployment output"
    echo "Deployment output:"
    echo "$DEPLOY_OUTPUT"
    exit 1
fi

echo "✅ Contract deployed successfully!"
echo "Contract Address: $CONTRACT_ADDRESS"

# =============================================================================
# SAVE DEPLOYMENT INFO
# =============================================================================

echo ""
echo "📝 Saving deployment information..."

# Create deployment info file
cat > deploy/deployment-info.txt << EOF
# LUV8 Token Deployment Information
# =================================

Deployment Date: $(date)
Network: Polygon Mainnet
Chain ID: $CHAIN_ID

## Contract Details
Contract Name: $CONTRACT_NAME
Contract Address: $CONTRACT_ADDRESS
Contract File: $CONTRACT_FILE
Verification File: $VERIFICATION_FILE

## Constructor Arguments
Team Wallet: $TEAM_WALLET
Liquidity Wallet: $LIQUIDITY_WALLET
Router Address: $QUICKSWAP_V2_ROUTER

## ABI-Encoded Constructor Arguments
$(cast abi-encode "constructor(address,address,address)" "$TEAM_WALLET" "$LIQUIDITY_WALLET" "$QUICKSWAP_V2_ROUTER")

## Verification Settings
Compiler Version: v0.8.30
Optimization: Enabled
Optimizer Runs: 200
Via IR: Enabled

## Network Information
RPC URL: $RPC_URL
Block Explorer: https://polygonscan.com
Contract URL: https://polygonscan.com/address/$CONTRACT_ADDRESS

## Router Information
QuickSwap V2 Router: $QUICKSWAP_V2_ROUTER
QuickSwap V3 Router: $QUICKSWAP_V3_ROUTER

## Token Information
Name: SHAMBA LUV
Symbol: LUV
Decimals: 18
Total Supply: 1,000,000,000 LUV

## Features
- Reflection mechanism
- Liquidity management
- Timelock security
- Multi-router support
- Gas optimization
- Batch processing
EOF

echo "✅ Deployment information saved to deploy/deployment-info.txt"

# =============================================================================
# VERIFICATION SCRIPT
# =============================================================================

echo ""
echo "🔧 Creating verification script..."

# Create verification script
cat > deploy/verify-contract.sh << EOF
#!/bin/bash

# LUV8 Contract Verification Script
# =================================

# Load environment variables
source .env

# Contract details
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
CONSTRUCTOR_ARGS="\$(cast abi-encode "constructor(address,address,address)" "$TEAM_WALLET" "$LIQUIDITY_WALLET" "$QUICKSWAP_V2_ROUTER")"

echo "🔧 Verifying LUV8 Contract on PolygonScan"
echo "Contract Address: \$CONTRACT_ADDRESS"
echo "Constructor Args: \$CONSTRUCTOR_ARGS"
echo "=================================================="

forge verify-contract \\
    "\$CONTRACT_ADDRESS" \\
    $VERIFICATION_FILE:$CONTRACT_NAME \\
    --chain-id $CHAIN_ID \\
    --etherscan-api-key "\$ETHERSCAN_API_KEY" \\
    --constructor-args "\$CONSTRUCTOR_ARGS" \\
    --compiler-version "v0.8.30" \\
    --optimizer-runs 200 \\
    --via-ir
EOF

chmod +x deploy/verify-contract.sh

echo "✅ Verification script created: deploy/verify-contract.sh"

# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

echo ""
echo "🎉 Deployment Complete!"
echo "======================"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Network: Polygon Mainnet"
echo "Block Explorer: https://polygonscan.com/address/$CONTRACT_ADDRESS"
echo ""
echo "📁 Files Created:"
echo "- deploy/deployment-info.txt (Deployment details)"
echo "- deploy/verify-contract.sh (Verification script)"
echo ""
echo "🔧 Next Steps:"
echo "1. Verify contract: ./deploy/verify-contract.sh"
echo "2. Add liquidity to QuickSwap"
echo "3. Configure additional settings"
echo "4. Test contract functions"
echo ""
echo "📋 Important Notes:"
echo "- Contract is deployed with reflection mechanism enabled"
echo "- Initial thresholds are set for optimal operation"
echo "- Security features (timelock, slippage protection) are active"
echo "- Team and liquidity wallets are configured"
echo ""
echo "✅ Deployment successful! 🚀" 
