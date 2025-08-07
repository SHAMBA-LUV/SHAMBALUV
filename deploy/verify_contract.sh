#!/bin/bash

# =============================================================================
# LUV8 Contract Verification Script - Correct Version
# =============================================================================
# This script verifies the contract using the exact settings that work:
# - Compiler Version: v0.8.30
# - Optimization: Enabled
# - Optimizer Runs: 200
# - Via IR: Enabled
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
VERIFICATION_FILE="deploy/LUV8_VERIFICATION.sol"
CHAIN_ID=137

# Correct verification settings (confirmed working)
COMPILER_VERSION="v0.8.30"
OPTIMIZER_RUNS=200
VIA_IR=true

# =============================================================================
# VALIDATION
# =============================================================================

echo "🔍 Validating verification configuration..."

# Check required environment variables
if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "❌ ETHERSCAN_API_KEY not set in .env file"
    exit 1
fi

if [ -z "$TEAM_WALLET" ]; then
    echo "❌ TEAM_WALLET not set in .env file"
    exit 1
fi

if [ -z "$LIQUIDITY_WALLET" ]; then
    echo "❌ LIQUIDITY_WALLET not set in .env file"
    exit 1
fi

# Check if verification file exists
if [ ! -f "$VERIFICATION_FILE" ]; then
    echo "❌ Verification file not found: $VERIFICATION_FILE"
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

echo "✅ Configuration validation passed"

# =============================================================================
# CONTRACT ADDRESS INPUT
# =============================================================================

echo ""
echo "📝 Contract Address Input"
echo "=========================="

# Check if contract address is provided as argument
if [ -n "$1" ]; then
    CONTRACT_ADDRESS="$1"
    echo "Using provided contract address: $CONTRACT_ADDRESS"
else
    # Ask for contract address
    read -p "Enter the contract address to verify: " CONTRACT_ADDRESS
fi

# Validate contract address
if [[ ! "$CONTRACT_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    echo "❌ Invalid contract address format"
    exit 1
fi

# =============================================================================
# CONSTRUCTOR ARGUMENTS
# =============================================================================

echo ""
echo "🔧 Generating constructor arguments..."

# Generate ABI-encoded constructor arguments
CONSTRUCTOR_ARGS=$(cast abi-encode "constructor(address,address,address)" "$TEAM_WALLET" "$LIQUIDITY_WALLET" "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff")

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate constructor arguments"
    exit 1
fi

echo "✅ Constructor arguments generated successfully"

# =============================================================================
# VERIFICATION INFORMATION
# =============================================================================

echo ""
echo "🔧 LUV8 Contract Verification - Correct Version"
echo "================================================"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Contract Name: $CONTRACT_NAME"
echo "Verification File: $VERIFICATION_FILE"
echo "Chain ID: $CHAIN_ID"
echo ""
echo "📋 Verification Settings (Confirmed Working):"
echo "- Compiler Version: $COMPILER_VERSION"
echo "- Optimization: Enabled"
echo "- Optimizer Runs: $OPTIMIZER_RUNS"
echo "- Via IR: $VIA_IR"
echo ""
echo "🔗 Constructor Arguments:"
echo "$CONSTRUCTOR_ARGS"
echo ""

# =============================================================================
# CONFIRMATION
# =============================================================================

read -p "Do you want to proceed with verification? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Verification cancelled"
    exit 1
fi

echo ""
echo "🚀 Starting verification process..."

# =============================================================================
# VERIFY CONTRACT
# =============================================================================

echo ""
echo "🔧 Submitting verification to PolygonScan..."

# Verify the contract with correct settings
VERIFY_OUTPUT=$(forge verify-contract \
    "$CONTRACT_ADDRESS" \
    "$VERIFICATION_FILE:$CONTRACT_NAME" \
    --chain-id "$CHAIN_ID" \
    --etherscan-api-key "$ETHERSCAN_API_KEY" \
    --constructor-args "$CONSTRUCTOR_ARGS" \
    --compiler-version "$COMPILER_VERSION" \
    --optimizer-runs "$OPTIMIZER_RUNS" \
    --via-ir)

# Check if verification was successful
if [ $? -eq 0 ]; then
    echo "✅ Verification submitted successfully!"
    echo ""
    echo "📋 Verification Details:"
    echo "- Contract: $CONTRACT_ADDRESS"
    echo "- Network: Polygon Mainnet"
    echo "- Compiler: $COMPILER_VERSION"
    echo "- Settings: Optimization enabled, $OPTIMIZER_RUNS runs, Via IR enabled"
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
    echo "🔍 Troubleshooting:"
    echo "1. Check if contract address is correct"
    echo "2. Verify API key is valid"
    echo "3. Ensure contract is deployed on Polygon"
    echo "4. Check if contract is already verified"
    exit 1
fi

# =============================================================================
# VERIFICATION STATUS CHECK
# =============================================================================

echo ""
echo "🔍 Checking verification status..."

# Wait a moment for verification to process
sleep 5

# Check if contract is verified
VERIFICATION_STATUS=$(curl -s "https://api.polygonscan.com/api?module=contract&action=getabi&address=$CONTRACT_ADDRESS&apikey=$ETHERSCAN_API_KEY" | jq -r '.status')

if [ "$VERIFICATION_STATUS" = "1" ]; then
    echo "✅ Contract is verified!"
    echo "🔗 View contract at: https://polygonscan.com/address/$CONTRACT_ADDRESS"
else
    echo "⏳ Verification is still processing..."
    echo "Please check manually at: https://polygonscan.com/address/$CONTRACT_ADDRESS"
fi

# =============================================================================
# SAVE VERIFICATION INFO
# =============================================================================

echo ""
echo "📝 Saving verification information..."

# Create verification info file
cat > deploy/verification-info.txt << EOF
# LUV8 Contract Verification Information
# =====================================

Verification Date: $(date)
Contract Address: $CONTRACT_ADDRESS
Contract Name: $CONTRACT_NAME
Network: Polygon Mainnet
Chain ID: $CHAIN_ID

## Verification Settings (Confirmed Working)
Compiler Version: $COMPILER_VERSION
Optimization: Enabled
Optimizer Runs: $OPTIMIZER_RUNS
Via IR: $VIA_IR

## Constructor Arguments
Team Wallet: $TEAM_WALLET
Liquidity Wallet: $LIQUIDITY_WALLET
Router Address: 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff

## ABI-Encoded Constructor Arguments
$CONSTRUCTOR_ARGS

## Verification File
Source File: $VERIFICATION_FILE

## Block Explorer
Contract URL: https://polygonscan.com/address/$CONTRACT_ADDRESS

## Notes
- This verification uses the exact settings that work for LUV8
- Compiler version v0.8.30 is crucial for bytecode matching
- Via IR must be enabled for correct compilation
- Optimization with 200 runs is required
EOF

echo "✅ Verification information saved to deploy/verification-info.txt"

# =============================================================================
# SUMMARY
# =============================================================================

echo ""
echo "🎉 Verification Process Complete!"
echo "================================"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Network: Polygon Mainnet"
echo "Compiler Version: $COMPILER_VERSION"
echo "Status: Submitted for verification"
echo ""
echo "📁 Files Created:"
echo "- deploy/verification-info.txt (Verification details)"
echo ""
echo "🔗 Links:"
echo "- Contract: https://polygonscan.com/address/$CONTRACT_ADDRESS"
echo "- Verification Info: deploy/verification-info.txt"
echo ""
echo "📋 Important Notes:"
echo "- Verification uses confirmed working settings"
echo "- Compiler version v0.8.30 is essential"
echo "- Via IR and optimization are required"
echo "- Check status manually if needed"
echo ""
echo "✅ Verification script completed successfully! 🚀" 
