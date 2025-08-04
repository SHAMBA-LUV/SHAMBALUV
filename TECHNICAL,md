# LUV Contract Technical Documentation

## Table of Contents
1. [Contract Overview](#contract-overview)
2. [Architecture & Design](#architecture--design)
3. [State Variables & Constants](#state-variables--constants)
4. [Core Functions](#core-functions)
5. [Fee System](#fee-system)
6. [Reflection System](#reflection-system)
7. [Wallet-to-Wallet Exemption](#wallet-to-wallet-exemption)
8. [Admin Functions](#admin-functions)
9. [Router Management](#router-management)
10. [Threshold Management](#threshold-management)
11. [Gas Optimization](#gas-optimization)
12. [Security Features](#security-features)
13. [Events](#events)
14. [Error Handling](#error-handling)
15. [Integration Points](#integration-points)
16. [Deployment Considerations](#deployment-considerations)

---

## Contract Overview

### Basic Information
- **Contract Name**: `LUV100Q`
- **Solidity Version**: `^0.8.30`
- **License**: UNLICENSED
- **Total Supply**: 100,000,000,000,000,000 tokens (100 Quadrillion)
- **Decimals**: 18

### Inheritance Chain
```
LUV100Q
├── ERC20 (OpenZeppelin)
├── Ownable (OpenZeppelin)
└── ReentrancyGuard (OpenZeppelin)
```

### Core Purpose
The LUV contract implements a sophisticated ERC20 token with advanced features including:
- **Reflection System**: Automatic distribution of fees to token holders
- **Fee Structure**: 5% total fee (3% reflection, 1% liquidity, 1% team)
- **Wallet-to-Wallet Exemption**: Fee-free transfers between EOAs
- **Gas Optimization**: Batch processing and local supply tracking
- **Multi-Router Support**: QuickSwap V2/V3 compatibility

---

## Architecture & Design

### Design Principles

#### 1. **Gas Efficiency**
- Local total supply tracking to avoid expensive storage reads
- Batch reflection processing to reduce gas costs
- Optimized fee calculations using integer arithmetic
- Minimal storage operations during transfers

#### 2. **Security First**
- ReentrancyGuard protection on all external functions
- Ownable pattern for admin functions
- Comprehensive input validation
- Safe math operations (Solidity 0.8.30 built-in)

#### 3. **Flexibility**
- Configurable fee structure
- Adjustable thresholds
- Router upgradeability
- Admin function controls

#### 4. **User Experience**
- Fee-free wallet-to-wallet transfers
- Automatic reflection distribution
- Transparent fee structure
- No trading pauses

### Contract Structure

```
LUV100Q Contract
├── Constants & Configuration
├── State Variables
├── Constructor
├── Core Transfer Logic
├── Fee Calculation System
├── Reflection Distribution
├── Admin Functions
├── Router Management
├── Threshold Controls
├── View Functions
└── Events & Error Handling
```

---

## State Variables & Constants

### Constants

#### **Supply & Fee Constants**
```solidity
uint256 public constant TOTAL_SUPPLY = 100_000_000_000_000_000 * 1e18; // 100 Quadrillion
uint256 public constant BASE_REFLECTION_FEE = 300;  // 3.00%
uint256 public constant BASE_LIQUIDITY_FEE = 100;   // 1.00%
uint256 public constant BASE_TEAM_FEE = 100;        // 1.00%
uint256 public constant FEE_DENOMINATOR = 10000;    // precision
uint256 public constant TOTAL_FEE_PERCENTAGE = BASE_REFLECTION_FEE + BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
```

**Purpose**: Define the immutable fee structure and total supply. The fee denominator (10,000) allows for precise percentage calculations with 2 decimal places of precision.

#### **Gas Optimization Constants**
```solidity
uint256 public constant REFLECTION_BATCH_THRESHOLD = 1_000_000_000_000 * 1e18; // 1 trillion
uint256 public constant REFLECTION_DENOMINATOR = 1e18;
```

**Purpose**: 
- `REFLECTION_BATCH_THRESHOLD`: Minimum accumulated fees before batch processing
- `REFLECTION_DENOMINATOR`: Precision for reflection calculations

#### **Router & Threshold Constants**
```solidity
uint256 public constant MAX_THRESHOLD = TOTAL_SUPPLY / 50; // Max 2% for any threshold
```

**Purpose**: Prevents excessive threshold values that could impact contract functionality.

#### **QuickSwap Router Addresses (Polygon)**
```solidity
address public constant QUICKSWAP_V2_ROUTER = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
address public constant QUICKSWAP_V3_ROUTER = 0xF5B509Bb0909A69B1c207e495F687a6C0eE0989e;
address public constant WPOL = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270; // WMATIC
```

**Purpose**: Hardcoded addresses for Polygon network QuickSwap integration.

### State Variables

#### **Fee & Reflection Tracking**
```solidity
uint256 private _localTotalSupply;           // Local supply tracking
uint256 private _accumulatedReflectionFees;  // Total reflection fees collected
uint256 private _totalReflectionFeesDistributed; // Total reflections distributed
uint256 private _reflectionIndex;            // Current reflection index
uint256 private _reflectionBatchThreshold;   // Batch processing threshold
```

**Purpose**: 
- `_localTotalSupply`: Gas optimization - avoids expensive storage reads
- `_accumulatedReflectionFees`: Tracks fees available for distribution
- `_totalReflectionFeesDistributed`: Tracks total distributed reflections
- `_reflectionIndex`: Mathematical index for reflection calculations
- `_reflectionBatchThreshold`: Configurable batch processing threshold

#### **Wallet & Router Management**
```solidity
address public teamWallet;                   // Team fee recipient
address public liquidityWallet;              // Liquidity fee recipient
address public admin;                        // Admin address
address public v2Router;                     // QuickSwap V2 router
address public v3Router;                     // QuickSwap V3 router
bool public usingV3Router;                   // Router version flag
```

**Purpose**: 
- `teamWallet`: Receives 1% team fees
- `liquidityWallet`: Receives 1% liquidity fees
- `admin`: Secondary admin with limited permissions
- `v2Router/v3Router`: Router addresses for swaps
- `usingV3Router`: Toggles between V2/V3 router usage

#### **Threshold & Control Variables**
```solidity
uint256 public teamThreshold;                // Team fee distribution threshold
uint256 public liquidityThreshold;           // Liquidity fee distribution threshold
uint256 public maxTransferAmount;            // Maximum transfer limit
bool public maxTransferEnabled;              // Max transfer toggle
bool public walletToWalletFeeExempt;        // Wallet-to-wallet exemption
```

**Purpose**: 
- `teamThreshold`: Minimum fees before team distribution
- `liquidityThreshold`: Minimum fees before liquidity distribution
- `maxTransferAmount`: Transfer limit (1% of total supply)
- `maxTransferEnabled`: Enables/disables transfer limits
- `walletToWalletFeeExempt`: Controls fee exemption for EOA transfers

#### **Exemption Mappings**
```solidity
mapping(address => bool) public isExemptFromFees;
mapping(address => bool) public isExemptFromMaxTransfer;
mapping(address => bool) public isExemptFromReflections;
```

**Purpose**: 
- `isExemptFromFees`: Exempts addresses from all fees
- `isExemptFromMaxTransfer`: Exempts addresses from transfer limits
- `isExemptFromReflections`: Exempts addresses from reflection distribution

---

## Core Functions

### Constructor

```solidity
constructor(
    address _teamWallet,
    address _liquidityWallet,
    address _admin
) ERC20("SHAMBA LUV", "LUV") Ownable() {
    require(_teamWallet != address(0), "Team wallet cannot be zero address");
    require(_liquidityWallet != address(0), "Liquidity wallet cannot be zero address");
    require(_admin != address(0), "Admin cannot be zero address");
    
    teamWallet = _teamWallet;
    liquidityWallet = _liquidityWallet;
    admin = _admin;
    
    _localTotalSupply = TOTAL_SUPPLY;
    _mint(msg.sender, TOTAL_SUPPLY);
    
    // Set initial exemptions
    isExemptFromFees[msg.sender] = true;
    isExemptFromMaxTransfer[msg.sender] = true;
    isExemptFromReflections[msg.sender] = true;
    isExemptFromFees[_teamWallet] = true;
    isExemptFromMaxTransfer[_teamWallet] = true;
    isExemptFromReflections[_teamWallet] = true;
    isExemptFromFees[_liquidityWallet] = true;
    isExemptFromMaxTransfer[_liquidityWallet] = true;
    isExemptFromReflections[_liquidityWallet] = true;
    
    // Initialize router
    v2Router = QUICKSWAP_V2_ROUTER;
    usingV3Router = false;
    
    // Set initial thresholds
    teamThreshold = 1_000_000_000_000 * 1e18; // 1 trillion
    liquidityThreshold = 1_000_000_000_000 * 1e18; // 1 trillion
    reflectionBatchThreshold = REFLECTION_BATCH_THRESHOLD;
    
    // Enable wallet-to-wallet exemption by default
    walletToWalletFeeExempt = true;
    
    // Set max transfer to 1% of total supply
    maxTransferAmount = TOTAL_SUPPLY / 100;
    maxTransferEnabled = true;
}
```

**Functionality**:
1. **Input Validation**: Ensures all wallet addresses are non-zero
2. **State Initialization**: Sets up all state variables with default values
3. **Token Minting**: Mints total supply to contract deployer
4. **Exemption Setup**: Exempts deployer and fee wallets from fees/limits
5. **Router Configuration**: Initializes QuickSwap V2 router
6. **Threshold Setup**: Sets initial thresholds for fee distribution
7. **Feature Enabling**: Enables wallet-to-wallet exemption and max transfer limits

### Transfer Function Override

```solidity
function _transfer(
    address sender,
    address recipient,
    uint256 amount
) internal virtual override {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    require(amount > 0, "ERC20: transfer amount must be greater than zero");
    
    // Check max transfer limit
    if (maxTransferEnabled && !isExemptFromMaxTransfer[sender]) {
        require(amount <= maxTransferAmount, "Transfer amount exceeds max limit");
    }
    
    // Check wallet-to-wallet exemption
    bool isWalletToWallet = sender.isContract() == false && recipient.isContract() == false;
    bool shouldExemptFromFees = walletToWalletFeeExempt && isWalletToWallet;
    
    if (shouldExemptFromFees || isExemptFromFees[sender] || isExemptFromFees[recipient]) {
        // Fee-free transfer
        super._transfer(sender, recipient, amount);
    } else {
        // Calculate fees
        uint256 reflectionFee = (amount * BASE_REFLECTION_FEE) / FEE_DENOMINATOR;
        uint256 liquidityFee = (amount * BASE_LIQUIDITY_FEE) / FEE_DENOMINATOR;
        uint256 teamFee = (amount * BASE_TEAM_FEE) / FEE_DENOMINATOR;
        uint256 totalFee = reflectionFee + liquidityFee + teamFee;
        uint256 transferAmount = amount - totalFee;
        
        // Update reflection tracking
        _updateReflectionTracking(sender, recipient, reflectionFee);
        
        // Transfer fees to contract
        super._transfer(sender, address(this), totalFee);
        
        // Transfer remaining amount to recipient
        super._transfer(sender, recipient, transferAmount);
        
        // Distribute fees
        _distributeFees(liquidityFee, teamFee);
    }
}
```

**Functionality**:
1. **Input Validation**: Validates sender, recipient, and amount
2. **Max Transfer Check**: Enforces transfer limits if enabled
3. **Wallet-to-Wallet Detection**: Determines if transfer is between EOAs
4. **Fee Exemption Logic**: Applies exemptions based on wallet type and exemptions
5. **Fee Calculation**: Calculates reflection, liquidity, and team fees
6. **Reflection Tracking**: Updates reflection system state
7. **Fee Distribution**: Distributes fees to appropriate wallets
8. **Transfer Execution**: Performs the actual token transfer

---

## Fee System

### Fee Structure Overview

The LUV contract implements a sophisticated 5% total fee structure:

```
Total Fee (5%)
├── Reflection Fee (3%) → Distributed to token holders
├── Liquidity Fee (1%) → Sent to liquidity wallet
└── Team Fee (1%) → Sent to team wallet
```

### Fee Calculation

```solidity
uint256 reflectionFee = (amount * BASE_REFLECTION_FEE) / FEE_DENOMINATOR;
uint256 liquidityFee = (amount * BASE_LIQUIDITY_FEE) / FEE_DENOMINATOR;
uint256 teamFee = (amount * BASE_TEAM_FEE) / FEE_DENOMINATOR;
uint256 totalFee = reflectionFee + liquidityFee + teamFee;
```

**Mathematical Precision**:
- Uses `FEE_DENOMINATOR = 10000` for 2 decimal place precision
- `BASE_REFLECTION_FEE = 300` represents 3.00%
- `BASE_LIQUIDITY_FEE = 100` represents 1.00%
- `BASE_TEAM_FEE = 100` represents 1.00%

### Fee Distribution Function

```solidity
function _distributeFees(uint256 liquidityFee, uint256 teamFee) private {
    // Distribute team fee
    if (teamFee > 0) {
        super._transfer(address(this), teamWallet, teamFee);
    }
    
    // Distribute liquidity fee
    if (liquidityFee > 0) {
        super._transfer(address(this), liquidityWallet, liquidityFee);
    }
}
```

**Functionality**:
1. **Team Fee Distribution**: Sends 1% fee directly to team wallet
2. **Liquidity Fee Distribution**: Sends 1% fee directly to liquidity wallet
3. **Gas Optimization**: Only transfers if fees are greater than zero

### Fee Exemption System

```solidity
mapping(address => bool) public isExemptFromFees;
```

**Exempt Addresses**:
- Contract deployer (owner)
- Team wallet
- Liquidity wallet
- Admin addresses
- Router contracts (for swaps)

**Exemption Logic**:
```solidity
if (shouldExemptFromFees || isExemptFromFees[sender] || isExemptFromFees[recipient]) {
    // Fee-free transfer
    super._transfer(sender, recipient, amount);
}
```

---

## Reflection System

### Overview

The reflection system automatically distributes 3% of each transaction fee to all token holders proportionally to their token balance.

### Reflection Tracking Variables

```solidity
uint256 private _accumulatedReflectionFees;      // Total fees collected
uint256 private _totalReflectionFeesDistributed; // Total fees distributed
uint256 private _reflectionIndex;                // Mathematical index
uint256 private _reflectionBatchThreshold;       // Batch processing threshold
```

### Reflection Update Function

```solidity
function _updateReflectionTracking(
    address sender,
    address recipient,
    uint256 reflectionFee
) private {
    if (reflectionFee > 0) {
        _accumulatedReflectionFees += reflectionFee;
        
        // Update reflection index
        if (_localTotalSupply > 0) {
            _reflectionIndex += (reflectionFee * REFLECTION_DENOMINATOR) / _localTotalSupply;
        }
        
        // Process batch if threshold met
        if (_accumulatedReflectionFees >= _reflectionBatchThreshold) {
            _processReflectionBatch();
        }
    }
}
```

**Functionality**:
1. **Fee Accumulation**: Adds reflection fee to accumulated total
2. **Index Update**: Updates mathematical reflection index
3. **Batch Processing**: Triggers batch processing when threshold met

### Reflection Index Calculation

The reflection index is a mathematical construct that tracks the total reflection value per token:

```solidity
_reflectionIndex += (reflectionFee * REFLECTION_DENOMINATOR) / _localTotalSupply;
```

**Formula Explanation**:
- `reflectionFee`: The reflection fee from the current transaction
- `REFLECTION_DENOMINATOR`: 1e18 for precision
- `_localTotalSupply`: Current total supply
- Result: Increase in reflection index per token

### Reflection Claiming

```solidity
function claimReflections() external nonReentrant {
    require(!isExemptFromReflections[msg.sender], "Exempt from reflections");
    
    uint256 currentReflectionIndex = _reflectionIndex;
    uint256 userReflectionIndex = _userReflectionIndex[msg.sender];
    
    require(currentReflectionIndex > userReflectionIndex, "No reflections to claim");
    
    uint256 userBalance = balanceOf(msg.sender);
    require(userBalance > 0, "No balance to claim reflections");
    
    uint256 reflectionAmount = (userBalance * (currentReflectionIndex - userReflectionIndex)) / REFLECTION_DENOMINATOR;
    
    require(reflectionAmount > 0, "No reflections to claim");
    
    _userReflectionIndex[msg.sender] = currentReflectionIndex;
    _totalReflectionFeesDistributed += reflectionAmount;
    
    super._transfer(address(this), msg.sender, reflectionAmount);
    
    emit ReflectionsClaimed(msg.sender, reflectionAmount);
}
```

**Functionality**:
1. **Exemption Check**: Ensures user is not exempt from reflections
2. **Index Comparison**: Compares current vs user reflection index
3. **Amount Calculation**: Calculates reflection amount based on balance and index difference
4. **State Update**: Updates user's reflection index and distributed total
5. **Token Transfer**: Transfers reflection tokens to user

### Batch Processing

```solidity
function _processReflectionBatch() private {
    if (_accumulatedReflectionFees >= _reflectionBatchThreshold) {
        // Process accumulated fees
        uint256 batchAmount = _accumulatedReflectionFees;
        _accumulatedReflectionFees = 0;
        
        // Update reflection index for batch
        if (_localTotalSupply > 0) {
            _reflectionIndex += (batchAmount * REFLECTION_DENOMINATOR) / _localTotalSupply;
        }
        
        emit ReflectionBatchProcessed(batchAmount);
    }
}
```

**Purpose**: 
- Reduces gas costs by processing reflections in batches
- Prevents excessive reflection processing on small transactions
- Maintains reflection accuracy while optimizing gas usage

---

## Wallet-to-Wallet Exemption

### Overview

The wallet-to-wallet exemption allows fee-free transfers between Externally Owned Accounts (EOAs), promoting user adoption and reducing friction.

### Exemption Detection

```solidity
bool isWalletToWallet = sender.isContract() == false && recipient.isContract() == false;
bool shouldExemptFromFees = walletToWalletFeeExempt && isWalletToWallet;
```

**Logic**:
- Uses `Address.isContract()` to detect contract addresses
- Only applies to EOA-to-EOA transfers
- Can be enabled/disabled by admin

### Exemption Control

```solidity
function setWalletToWalletFeeExempt(bool _exempt) external onlyOwner {
    walletToWalletFeeExempt = _exempt;
    emit WalletToWalletFeeExemptUpdated(_exempt);
}
```

**Functionality**:
- Allows owner to enable/disable wallet-to-wallet exemption
- Emits event for transparency
- Only owner can modify this setting

### Transfer Types

1. **EOA to EOA**: Fee-free when exemption enabled
2. **EOA to Contract**: Normal fees apply
3. **Contract to EOA**: Normal fees apply
4. **Contract to Contract**: Normal fees apply

---

## Admin Functions

### Admin Management

```solidity
function setAdmin(address _admin) external onlyOwner {
    require(_admin != address(0), "Admin cannot be zero address");
    admin = _admin;
    emit AdminUpdated(_admin);
}

function changeAdminByAdmin(address _newAdmin) external {
    require(msg.sender == admin, "Not admin");
    require(_newAdmin != address(0), "Admin cannot be zero address");
    admin = _newAdmin;
    emit AdminUpdated(_newAdmin);
}

function renounceAdminRole() external {
    require(msg.sender == admin, "Not admin");
    admin = address(0);
    emit AdminRoleRenounced();
}
```

**Purpose**:
- `setAdmin`: Owner can set initial admin
- `changeAdminByAdmin`: Admin can transfer admin role
- `renounceAdminRole`: Admin can renounce admin role

### Fee Exemption Management

```solidity
function setFeeExemption(address _address, bool _exempt) external onlyOwner {
    isExemptFromFees[_address] = _exempt;
    emit FeeExemptionUpdated(_address, _exempt);
}

function setMaxTransferExemption(address _address, bool _exempt) external onlyOwner {
    isExemptFromMaxTransfer[_address] = _exempt;
    emit MaxTransferExemptionUpdated(_address, _exempt);
}

function setReflectionExemption(address _address, bool _exempt) external onlyOwner {
    isExemptFromReflections[_address] = _exempt;
    emit ReflectionExemptionUpdated(_address, _exempt);
}
```

**Functionality**:
- Allows owner to exempt addresses from fees, transfer limits, or reflections
- Provides granular control over contract behavior
- Emits events for transparency

### Wallet Management

```solidity
function setTeamWallet(address _teamWallet) external onlyOwner {
    require(_teamWallet != address(0), "Team wallet cannot be zero address");
    teamWallet = _teamWallet;
    emit TeamWalletUpdated(_teamWallet);
}

function setLiquidityWallet(address _liquidityWallet) external onlyOwner {
    require(_liquidityWallet != address(0), "Liquidity wallet cannot be zero address");
    liquidityWallet = _liquidityWallet;
    emit LiquidityWalletUpdated(_liquidityWallet);
}
```

**Purpose**:
- Allows owner to update fee recipient wallets
- Ensures proper fee distribution
- Maintains contract functionality

---

## Router Management

### Router Configuration

```solidity
function updateV2Router(address _router) external onlyOwner {
    require(_router != address(0), "Router cannot be zero address");
    require(_router != v2Router, "Already set");
    v2Router = _router;
    emit V2RouterUpdated(_router);
}

function setV3Router(address _router) external onlyOwner {
    require(_router != address(0), "Router cannot be zero address");
    v3Router = _router;
    emit V3RouterUpdated(_router);
}

function toggleRouterVersion() external onlyOwner {
    require(v3Router != address(0), "V3 router not set");
    usingV3Router = !usingV3Router;
    emit RouterVersionToggled(usingV3Router);
}
```

**Functionality**:
- `updateV2Router`: Updates QuickSwap V2 router address
- `setV3Router`: Sets QuickSwap V3 router address
- `toggleRouterVersion`: Switches between V2 and V3 router usage

### Router Status Functions

```solidity
function getRouterConfig() external view returns (
    address v2RouterAddress,
    address v3RouterAddress,
    bool usingV3
) {
    return (v2Router, v3Router, usingV3Router);
}

function getRouterStatus() external view returns (
    address currentRouter,
    bool isV3
) {
    return (usingV3Router ? v3Router : v2Router, usingV3Router);
}
```

**Purpose**:
- Provides transparency about router configuration
- Allows external systems to query router status
- Facilitates integration with DEX protocols

---

## Threshold Management

### Threshold Configuration

```solidity
function setThresholds(uint256 _teamThreshold, uint256 _liquidityThreshold) external onlyOwner {
    require(_teamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    require(_liquidityThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    
    teamThreshold = _teamThreshold;
    liquidityThreshold = _liquidityThreshold;
    
    emit ThresholdsUpdated(_teamThreshold, _liquidityThreshold);
}

function emergencyIncreaseThresholds(uint256 _teamIncrease, uint256 _liquidityIncrease) external onlyOwner {
    require(_teamIncrease > 0 || _liquidityIncrease > 0, "Must increase at least one");
    
    if (_teamIncrease > 0) {
        teamThreshold += _teamIncrease;
        require(teamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    }
    
    if (_liquidityIncrease > 0) {
        liquidityThreshold += _liquidityIncrease;
        require(liquidityThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    }
    
    emit ThresholdsEmergencyIncreased(_teamIncrease, _liquidityIncrease);
}
```

**Functionality**:
- `setThresholds`: Sets new threshold values (can only increase)
- `emergencyIncreaseThresholds`: Emergency function to increase thresholds
- Both functions enforce maximum threshold limits

### Reflection Threshold Management

```solidity
function setReflectionThreshold(uint256 _threshold) external onlyOwner {
    require(_threshold > 0, "Threshold must be greater than zero");
    reflectionBatchThreshold = _threshold;
    emit ReflectionThresholdUpdated(_threshold);
}
```

**Purpose**:
- Controls batch processing frequency
- Balances gas optimization vs reflection accuracy
- Allows fine-tuning of reflection system

---

## Gas Optimization

### Local Total Supply Tracking

```solidity
uint256 private _localTotalSupply;
```

**Purpose**:
- Avoids expensive storage reads during transfers
- Maintains accurate supply tracking
- Reduces gas costs significantly

### Batch Processing

```solidity
uint256 public constant REFLECTION_BATCH_THRESHOLD = 1_000_000_000_000 * 1e18;
```

**Purpose**:
- Processes reflections in batches to reduce gas costs
- Prevents excessive processing on small transactions
- Maintains reflection accuracy

### Optimized Fee Calculations

```solidity
uint256 reflectionFee = (amount * BASE_REFLECTION_FEE) / FEE_DENOMINATOR;
uint256 liquidityFee = (amount * BASE_LIQUIDITY_FEE) / FEE_DENOMINATOR;
uint256 teamFee = (amount * BASE_TEAM_FEE) / FEE_DENOMINATOR;
```

**Optimization**:
- Uses integer arithmetic for precision
- Avoids floating-point operations
- Minimizes computational overhead

### Gas Statistics Function

```solidity
function getGasOptimizationStats() external view returns (
    uint256 localTotalSupplyValue,
    uint256 accumulatedFees,
    uint256 batchThreshold
) {
    return (_localTotalSupply, _accumulatedReflectionFees, reflectionBatchThreshold);
}
```

**Purpose**:
- Provides transparency about gas optimization metrics
- Allows monitoring of batch processing efficiency
- Facilitates gas optimization analysis

---

## Security Features

### Reentrancy Protection

```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LUV100Q is ERC20, Ownable, ReentrancyGuard {
    function claimReflections() external nonReentrant {
        // Function implementation
    }
}
```

**Protection**:
- Prevents reentrant attacks on reflection claiming
- Protects against malicious contract interactions
- Ensures state consistency

### Input Validation

```solidity
require(sender != address(0), "ERC20: transfer from the zero address");
require(recipient != address(0), "ERC20: transfer to the zero address");
require(amount > 0, "ERC20: transfer amount must be greater than zero");
```

**Validation**:
- Prevents transfers to/from zero address
- Ensures positive transfer amounts
- Validates all external inputs

### Access Control

```solidity
modifier onlyOwner() {
    require(owner() == msg.sender, "Not owner");
    _;
}

function setAdmin(address _admin) external onlyOwner {
    // Function implementation
}
```

**Control**:
- Owner-only functions for critical operations
- Admin functions for secondary operations
- Granular permission system

### Maximum Limits

```solidity
uint256 public constant MAX_THRESHOLD = TOTAL_SUPPLY / 50; // Max 2%

require(_teamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
```

**Limits**:
- Prevents excessive threshold values
- Maintains contract stability
- Protects against configuration errors

---

## Events

### Transfer Events

```solidity
event LogTransfer(address indexed from, address indexed to, uint256 amount, uint256 fee);
event LogFeeCalculation(uint256 amount, uint256 reflectionFee, uint256 liquidityFee, uint256 teamFee);
```

**Purpose**:
- Provides transparency for transfers
- Logs fee calculations for auditing
- Enables external monitoring

### Admin Events

```solidity
event AdminUpdated(address indexed newAdmin);
event AdminRoleRenounced();
event FeeExemptionUpdated(address indexed account, bool exempt);
event MaxTransferExemptionUpdated(address indexed account, bool exempt);
event ReflectionExemptionUpdated(address indexed account, bool exempt);
```

**Purpose**:
- Tracks admin changes
- Logs exemption updates
- Provides audit trail

### Router Events

```solidity
event V2RouterUpdated(address indexed router);
event V3RouterUpdated(address indexed router);
event RouterVersionToggled(bool usingV3);
```

**Purpose**:
- Tracks router configuration changes
- Enables external monitoring
- Facilitates integration

### Threshold Events

```solidity
event ThresholdsUpdated(uint256 teamThreshold, uint256 liquidityThreshold);
event ThresholdsEmergencyIncreased(uint256 teamIncrease, uint256 liquidityIncrease);
event ReflectionThresholdUpdated(uint256 threshold);
```

**Purpose**:
- Logs threshold changes
- Provides transparency
- Enables monitoring

### Reflection Events

```solidity
event ReflectionsClaimed(address indexed user, uint256 amount);
event ReflectionBatchProcessed(uint256 batchAmount);
```

**Purpose**:
- Tracks reflection claims
- Logs batch processing
- Enables reflection monitoring

### Wallet Events

```solidity
event TeamWalletUpdated(address indexed wallet);
event LiquidityWalletUpdated(address indexed wallet);
event WalletToWalletFeeExemptUpdated(bool exempt);
```

**Purpose**:
- Tracks wallet changes
- Provides transparency
- Enables monitoring

---

## Error Handling

### Custom Errors

The contract uses OpenZeppelin's standard error handling and custom require statements:

```solidity
require(_teamWallet != address(0), "Team wallet cannot be zero address");
require(_liquidityWallet != address(0), "Liquidity wallet cannot be zero address");
require(_admin != address(0), "Admin cannot be zero address");
```

### Error Categories

1. **Input Validation Errors**:
   - Zero address checks
   - Positive amount validation
   - Threshold limit enforcement

2. **Access Control Errors**:
   - Owner-only function protection
   - Admin permission checks
   - Role-based access control

3. **Business Logic Errors**:
   - Transfer limit enforcement
   - Reflection claim validation
   - Fee calculation errors

4. **State Consistency Errors**:
   - Balance validation
   - Index consistency checks
   - Threshold validation

---

## Integration Points

### Uniswap V2 Integration

```solidity
interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
```

**Integration**:
- QuickSwap V2 router compatibility
- Fee-on-transfer token support
- ETH output functionality

### Uniswap V3 Integration

```solidity
interface IUniswapV3SwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }
    
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}
```

**Integration**:
- QuickSwap V3 router compatibility
- Advanced swap parameters
- Price limit protection

### OpenZeppelin Integration

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
```

**Components**:
- ERC20: Standard token functionality
- Ownable: Access control
- ReentrancyGuard: Security protection
- Address: Utility functions

---

## Deployment Considerations

### Network Compatibility

**Polygon Network**:
- QuickSwap V2/V3 router addresses
- WMATIC (WPOL) address
- Gas optimization for Polygon

**Other Networks**:
- Router addresses need updating
- WETH address configuration
- Network-specific optimizations

### Gas Optimization

**Deployment**:
- Use Solidity 0.8.30 for latest optimizations
- Enable optimizer with 200 runs
- Use via_ir for better optimization

**Runtime**:
- Batch processing reduces gas costs
- Local supply tracking minimizes storage reads
- Efficient fee calculations

### Security Considerations

**Pre-deployment**:
- Audit all admin functions
- Verify exemption logic
- Test fee calculations thoroughly

**Post-deployment**:
- Monitor reflection distribution
- Track fee accumulation
- Verify router functionality

### Configuration

**Initial Setup**:
- Set appropriate wallet addresses
- Configure initial thresholds
- Enable/disable features as needed

**Ongoing Management**:
- Monitor and adjust thresholds
- Update router addresses if needed
- Manage exemptions carefully

---

## Conclusion

The LUV contract represents a sophisticated implementation of a reflection token with advanced features including:

1. **Comprehensive Fee System**: 5% total fee with reflection, liquidity, and team distribution
2. **Advanced Reflection System**: Automatic distribution with batch processing and gas optimization
3. **Wallet-to-Wallet Exemption**: Fee-free transfers between EOAs for better user experience
4. **Flexible Admin Controls**: Granular permission system with owner and admin roles
5. **Multi-Router Support**: QuickSwap V2/V3 compatibility for future expansion
6. **Gas Optimization**: Local supply tracking and batch processing for efficiency
7. **Security Features**: Reentrancy protection, input validation, and access controls

The contract is designed for production deployment on Polygon with QuickSwap integration, providing a robust foundation for a reflection token with advanced features and excellent user experience. 
