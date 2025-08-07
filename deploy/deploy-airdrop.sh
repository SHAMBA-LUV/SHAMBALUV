#!/bin/bash

# =============================================================================
# ShambaLuvAirdrop Contract Deployment Script
# =============================================================================
# This script deploys and verifies the ShambaLuvAirdrop contract
# 
# Features:
# - Deploys airdrop contract with default token
# - Automatic verification on PolygonScan
# - Comprehensive validation and error handling
# - Deployment information documentation
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
CONTRACT_NAME="ShambaLuvAirdrop"
CONTRACT_FILE="deploy/ShambaLuvAirdrop.sol"
VERIFICATION_FILE="deploy/ShambaLuvAirdrop_VERIFICATION.sol"
CHAIN_ID=137

# Network configuration
NETWORK_ID=137  # Polygon Mainnet
RPC_URL="https://polygon-rpc.com"

# Default airdrop amount (1 trillion tokens)
DEFAULT_AIRDROP_AMOUNT="1000000000000000000000000000000" # 1 trillion with 18 decimals

# =============================================================================
# VALIDATION
# =============================================================================

echo "🔍 Validating deployment configuration..."

# Check required environment variables
if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ PRIVATE_KEY not set in .env file"
    exit 1
fi

if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "❌ ETHERSCAN_API_KEY not set in .env file"
    exit 1
fi

# Check if contract file exists
if [ ! -f "$CONTRACT_FILE" ]; then
    echo "❌ Contract file not found: $CONTRACT_FILE"
    exit 1
fi

# Check if verification file exists
if [ ! -f "$VERIFICATION_FILE" ]; then
    echo "❌ Verification file not found: $VERIFICATION_FILE"
    exit 1
fi

echo "✅ Configuration validation passed"

# =============================================================================
# DEFAULT TOKEN ADDRESS INPUT
# =============================================================================

echo ""
echo "📝 Default Token Address Input"
echo "==============================="

# Check if default token address is provided as argument
if [ -n "$1" ]; then
    DEFAULT_TOKEN_ADDRESS="$1"
    echo "Using provided default token address: $DEFAULT_TOKEN_ADDRESS"
else
    # Check if LUV8 contract address is available
    if [ -n "$LUV8_CONTRACT_ADDRESS" ]; then
        DEFAULT_TOKEN_ADDRESS="$LUV8_CONTRACT_ADDRESS"
        echo "Using LUV8 contract address from .env: $DEFAULT_TOKEN_ADDRESS"
    else
        # Ask for default token address
        read -p "Enter the default token address for airdrops: " DEFAULT_TOKEN_ADDRESS
    fi
fi

# Validate token address
if [[ ! "$DEFAULT_TOKEN_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "❌ Invalid token address format"
    exit 1
fi

# =============================================================================
# DEPLOYMENT INFORMATION
# =============================================================================

echo ""
echo "🚀 ShambaLuvAirdrop Contract Deployment"
echo "========================================"
echo "Network: Polygon Mainnet"
echo "Contract: $CONTRACT_NAME"
echo "Default Token: $DEFAULT_TOKEN_ADDRESS"
echo "Default Airdrop Amount: 1,000,000,000,000 tokens"
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
echo "🚀 Deploying airdrop contract..."

# Deploy the contract
DEPLOY_OUTPUT=$(forge create \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --chain-id "$CHAIN_ID" \
    --broadcast \
    "$CONTRACT_FILE:$CONTRACT_NAME" \
    --constructor-args "$DEFAULT_TOKEN_ADDRESS")

# Extract contract address
CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -o "Deployed to: 0x[a-fA-F0-9]*" | cut -d' ' -f3)

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Failed to extract contract address from deployment output"
    echo "Deployment output:"
    echo "$DEPLOY_OUTPUT"
    exit 1
fi

echo "✅ Airdrop contract deployed successfully!"
echo "Contract Address: $CONTRACT_ADDRESS"

# =============================================================================
# GENERATE CONSTRUCTOR ARGUMENTS
# =============================================================================

echo ""
echo "🔧 Generating constructor arguments for verification..."

# Generate ABI-encoded constructor arguments
CONSTRUCTOR_ARGS=$(cast abi-encode "constructor(address)" "$DEFAULT_TOKEN_ADDRESS")

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate constructor arguments"
    exit 1
fi

echo "✅ Constructor arguments generated successfully"
echo "Constructor Args: $CONSTRUCTOR_ARGS"

# =============================================================================
# SAVE DEPLOYMENT INFO
# =============================================================================

echo ""
echo "📝 Saving deployment information..."

# Create deployment info file
cat > deploy/airdrop-deployment-info.txt << EOF
# ShambaLuvAirdrop Contract Deployment Information
# ================================================

Deployment Date: $(date)
Network: Polygon Mainnet
Chain ID: $CHAIN_ID

## Contract Details
Contract Name: $CONTRACT_NAME
Contract Address: $CONTRACT_ADDRESS
Contract File: $CONTRACT_FILE
Verification File: $VERIFICATION_FILE

## Constructor Arguments
Default Token Address: $DEFAULT_TOKEN_ADDRESS

## ABI-Encoded Constructor Arguments
$CONSTRUCTOR_ARGS

## Verification Settings
Compiler Version: v0.8.30
Optimization: Enabled
Optimizer Runs: 200
Via IR: Enabled

## Network Information
RPC URL: $RPC_URL
Block Explorer: https://polygonscan.com
Contract URL: https://polygonscan.com/address/$CONTRACT_ADDRESS

## Airdrop Configuration
Default Airdrop Amount: 1,000,000,000,000 tokens (1 trillion)
Default Token: $DEFAULT_TOKEN_ADDRESS

## Features
- Flexible airdrop for any ERC20 token
- One-time claim per address per token
- Emergency withdrawal functions
- Token rescue capabilities
- Comprehensive admin controls
- Reentrancy protection
EOF

echo "✅ Deployment information saved to deploy/airdrop-deployment-info.txt"

# =============================================================================
# VERIFICATION SCRIPT
# =============================================================================

echo ""
echo "🔧 Creating verification script..."

# Create verification script
cat > deploy/verify-airdrop.sh << EOF
#!/bin/bash

# ShambaLuvAirdrop Contract Verification Script
# =============================================

# Load environment variables
source .env

# Contract details
CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
CONSTRUCTOR_ARGS="$CONSTRUCTOR_ARGS"

echo "🔧 Verifying ShambaLuvAirdrop Contract on PolygonScan"
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

chmod +x deploy/verify-airdrop.sh

echo "✅ Verification script created: deploy/verify-airdrop.sh"

# =============================================================================
# VERIFY CONTRACT
# =============================================================================

echo ""
echo "🔧 Verifying contract on PolygonScan..."

# Verify the contract
VERIFY_OUTPUT=$(forge verify-contract \
    "$CONTRACT_ADDRESS" \
    "$VERIFICATION_FILE:$CONTRACT_NAME" \
    --chain-id "$CHAIN_ID" \
    --etherscan-api-key "$ETHERSCAN_API_KEY" \
    --constructor-args "$CONSTRUCTOR_ARGS" \
    --compiler-version "v0.8.30" \
    --optimizer-runs 200 \
    --via-ir)

# Check if verification was successful
if [ $? -eq 0 ]; then
    echo "✅ Verification submitted successfully!"
    echo ""
    echo "📋 Verification Details:"
    echo "- Contract: $CONTRACT_ADDRESS"
    echo "- Network: Polygon Mainnet"
    echo "- Compiler: v0.8.30"
    echo "- Settings: Optimization enabled, 200 runs, Via IR enabled"
    echo ""
    echo "🔗 Check verification status at:"
    echo "https://polygonscan.com/address/$CONTRACT_ADDRESS"
    echo ""
    echo "⏳ Verification may take a few minutes to process..."
else
    echo "❌ Verification failed!"
    echo ""
    echo "📋 Error Details:"
    echo "$VERIFY_OUTPUT"
    echo ""
    echo "🔍 You can try manual verification using:"
    echo "./deploy/verify-airdrop.sh"
fi

# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

echo ""
echo "🎉 Deployment Complete!"
echo "======================"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Network: Polygon Mainnet"
echo "Default Token: $DEFAULT_TOKEN_ADDRESS"
echo "Block Explorer: https://polygonscan.com/address/$CONTRACT_ADDRESS"
echo ""
echo "📁 Files Created:"
echo "- deploy/airdrop-deployment-info.txt (Deployment details)"
echo "- deploy/verify-airdrop.sh (Verification script)"
echo ""
echo "🔧 Next Steps:"
echo "1. Verify contract: ./deploy/verify-airdrop.sh (if not already verified)"
echo "2. Deposit tokens to the airdrop contract"
echo "3. Configure airdrop settings"
echo "4. Test airdrop functionality"
echo ""
echo "📋 Important Notes:"
echo "- Contract is deployed with default token configured"
echo "- Default airdrop amount is 1 trillion tokens"
echo "- One-time claim per address per token"
echo "- Emergency functions are available for owner"
echo "- Contract supports multiple token types"
echo ""
echo "🔗 Contract Functions:"
echo "- claimAirdrop() - Claim default token airdrop"
echo "- claimAirdropForToken(address) - Claim specific token airdrop"
echo "- setAirdropConfig(address, uint256, bool) - Configure airdrop"
echo "- depositTokens(address, uint256) - Deposit tokens"
echo "- emergencyWithdraw(address) - Emergency withdrawal"
echo ""
echo "✅ Airdrop deployment successful! 🚀" 
