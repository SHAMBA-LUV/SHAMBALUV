#!/bin/bash

# ShambaLuvAirdrop Contract Verification Script
# =============================================

# Load environment variables
source .env

# Contract details
CONTRACT_ADDRESS="0x583F6D336E777c461FbfbeE3349D7D2dA9dc5e51"
CONSTRUCTOR_ARGS="0x0000000000000000000000001035760d0f60b35b63660ac0774ef363eaa5456e"

echo "🔧 Verifying ShambaLuvAirdrop Contract on PolygonScan"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Constructor Args: $CONSTRUCTOR_ARGS"
echo "=================================================="

forge verify-contract \
    "$CONTRACT_ADDRESS" \
    deploy/ShambaLuvAirdrop_VERIFICATION.sol:ShambaLuvAirdrop \
    --chain-id 137 \
    --etherscan-api-key "$ETHERSCAN_API_KEY" \
    --constructor-args "$CONSTRUCTOR_ARGS" \
    --compiler-version "v0.8.30" \
    --optimizer-runs 200 \
    --via-ir
