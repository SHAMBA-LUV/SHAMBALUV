# SHAMBA LUV Token Team Payment System - Technical Documentation

## Table of Contents
1. [Overview](#overview)
2. [Team Payment Architecture](#team-payment-architecture)
3. [Fee Structure Integration](#fee-structure-integration)
4. [Team Wallet Management](#team-wallet-management)
5. [Payment Distribution Mechanism](#payment-distribution-mechanism)
6. [Swap and Conversion Process](#swap-and-conversion-process)
7. [Threshold Management](#threshold-management)
8. [Security and Access Controls](#security-and-access-controls)
9. [Multi-Chain Support](#multi-chain-support)
10. [Router Integration](#router-integration)
11. [Payment Flow Analysis](#payment-flow-analysis)
12. [Admin Controls](#admin-controls)
13. [Monitoring and Analytics](#monitoring-and-analytics)
14. [Risk Management](#risk-management)
15. [Troubleshooting and Maintenance](#troubleshooting-and-maintenance)

---

## Overview

The SHAMBA LUV token implements a sophisticated **team payment system** that automatically collects and distributes **1% of all trading fees** to a designated team wallet. This system operates seamlessly within the broader fee structure, converting collected tokens to native cryptocurrency (ETH/WMATIC) and distributing them to support marketing and project management activities.

### Key Features
- **Automatic Collection**: 1% fee collected from every trading transaction
- **Token-to-Native Conversion**: Automatic conversion to ETH/WMATIC via DEX
- **Threshold-Based Distribution**: Configurable minimum amounts before distribution
- **Multi-Router Support**: Compatible with Uniswap V2 and V3
- **Real-time Processing**: Immediate conversion and distribution
- **Security Controls**: Owner-only wallet management and threshold controls

---

## Team Payment Architecture

### Core Principle
The team payment system operates on a **fee collection and conversion model** where:
1. **1% of every transaction** is automatically collected
2. **Accumulated tokens** are converted to native cryptocurrency
3. **Native currency** is distributed to the team wallet
4. **Process repeats** when thresholds are met

### System Flow
```
Transaction → Fee Collection → Token Accumulation → Threshold Check → DEX Swap → Native Distribution
     ↓              ↓                    ↓                    ↓              ↓              ↓
  1% Fee → Contract Balance → Monitor Threshold → Swap to ETH/WMATIC → Send to Team Wallet
```

---

## Fee Structure Integration

### Overall Fee Breakdown
```
Total Fee: 5%
├── Reflection Fee: 3% (distributed to holders)
├── Liquidity Fee: 1% (added to liquidity pool)
└── Team Fee: 1% (sent to team wallet)
```

### Team Fee Constants
```solidity
uint256 public constant BASE_TEAM_FEE = 100;        // 1.00%
uint256 public constant FEE_DENOMINATOR = 10000;    // Precision basis
uint256 public constant TOTAL_FEE_PERCENTAGE = BASE_REFLECTION_FEE + BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
```

### Fee Calculation
```solidity
uint256 teamFee = (amount * BASE_TEAM_FEE) / FEE_DENOMINATOR;
// Example: 1000 tokens * 100 / 10000 = 10 tokens (1%)
```

---

## Team Wallet Management

### State Variables
```solidity
address public teamWallet;                    // Team fee recipient
uint256 public teamSwapThreshold;             // Minimum tokens before swap
```

### Constructor Initialization
```solidity
constructor(
    address _teamWallet,
    address _liquidityWallet,
    address _router
) ERC20("SHAMBA LUV", "LUV") Ownable(msg.sender) {
    require(_teamWallet != address(0), "Invalid team wallet");
    teamWallet = _teamWallet;
    // ... other initialization
}
```

### Wallet Update Function
```solidity
function setTeamWallet(address _teamWallet) external onlyOwner {
    require(_teamWallet != address(0), "Zero address");
    
    address oldWallet = teamWallet;
    teamWallet = _teamWallet;
    
    emit WalletUpdated("team", oldWallet, _teamWallet);
}
```

### Security Features
- **Owner-only updates**: Only contract owner can change team wallet
- **Zero address validation**: Prevents setting invalid addresses
- **Event emission**: Transparent tracking of wallet changes
- **Immediate effect**: Changes take effect immediately

---

## Payment Distribution Mechanism

### Automatic Distribution Trigger
```solidity
function _maybeSwapBack() private swapping {
    uint256 contractBalance = balanceOf(address(this));
    
    if (contractBalance == 0) return;
    
    // Check thresholds
    bool shouldSwapTeam = contractBalance >= teamSwapThreshold;
    bool shouldSwapLiquidity = contractBalance >= liquidityThreshold;
    
    if (!shouldSwapTeam && !shouldSwapLiquidity) return;
    
    uint256 totalFee = BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
    uint256 swapAmount = (contractBalance * totalFee) / TOTAL_FEE_PERCENTAGE;
    
    // Perform swap
    if (useV3Router && address(v3Router) != address(0)) {
        _swapBackV3(swapAmount);
    } else {
        _swapBackV2(swapAmount);
    }
}
```

### Distribution Logic
The system distributes ETH/WMATIC proportionally between team and liquidity wallets:

```solidity
uint256 totalFee = BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
uint256 teamShare = (ethBalance * BASE_TEAM_FEE) / totalFee;
uint256 liquidityShare = ethBalance - teamShare;

if (teamShare > 0) {
    payable(teamWallet).sendValue(teamShare);
}
```

### Proportional Distribution Example
- **Total ETH received**: 100 ETH
- **Team fee percentage**: 1% of 5% total = 20% of swap proceeds
- **Team share**: 100 ETH × 1 / (1 + 1) = 50 ETH
- **Liquidity share**: 100 ETH - 50 ETH = 50 ETH

---

## Swap and Conversion Process

### Uniswap V2 Implementation
```solidity
function _swapBackV2(uint256 amount) private {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = WETH;
    
    uint256 beforeBalance = address(this).balance;
    router.swapExactTokensForETHSupportingFeeOnTransferTokens(
        amount,
        0,  // No slippage protection (accept any amount)
        path,
        address(this),
        block.timestamp
    );
    uint256 received = address(this).balance - beforeBalance;
    require(received > 0, "No ETH received from swap");
    
    // Distribute ETH
    uint256 ethBalance = address(this).balance;
    uint256 totalFee = BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
    uint256 teamShare = (ethBalance * BASE_TEAM_FEE) / totalFee;
    
    if (teamShare > 0) {
        payable(teamWallet).sendValue(teamShare);
    }
}
```

### Uniswap V3 Implementation
```solidity
function _swapBackV3(uint256 amount) private {
    IUniswapV3SwapRouter.ExactInputSingleParams memory params = IUniswapV3SwapRouter.ExactInputSingleParams({
        tokenIn: address(this),
        tokenOut: WETH,
        fee: 3000, // 0.3% fee tier
        recipient: address(this),
        deadline: block.timestamp,
        amountIn: amount,
        amountOutMinimum: 0,
        sqrtPriceLimitX96: 0
    });
    
    uint256 amountOut = v3Router.exactInputSingle(params);
    uint256 totalFee = BASE_LIQUIDITY_FEE + BASE_TEAM_FEE;
    uint256 teamShare = (amountOut * BASE_TEAM_FEE) / totalFee;
    
    if (teamShare > 0) {
        payable(teamWallet).sendValue(teamShare);
    }
}
```

### Key Features
- **Slippage tolerance**: Accepts any amount to ensure swap completion
- **Deadline protection**: Uses `block.timestamp` for immediate execution
- **Path optimization**: Direct token-to-ETH/WMATIC conversion
- **Error handling**: Requires positive ETH reception

---

## Threshold Management

### Default Threshold
```solidity
uint256 public teamSwapThreshold = 1_000_000_000_000 * 1e18; // 1 trillion tokens
```

### Threshold Setting
```solidity
function setThresholds(uint256 _teamThreshold, uint256 _liquidityThreshold) external onlyOwner {
    require(_teamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    require(_liquidityThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    
    teamSwapThreshold = _teamThreshold;
    liquidityThreshold = _liquidityThreshold;
    
    emit ThresholdsUpdated(_teamThreshold, _liquidityThreshold);
}
```

### Emergency Threshold Increase
```solidity
function emergencyIncreaseThresholds(
    uint256 _newTeamThreshold,
    uint256 _newLiquidityThreshold
) external onlyAdmin {
    require(_newTeamThreshold >= teamSwapThreshold, "Can only increase");
    require(_newTeamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
    
    uint256 oldTeamThreshold = teamSwapThreshold;
    teamSwapThreshold = _newTeamThreshold;
    
    emit EmergencyThresholdUpdate(oldTeamThreshold, _newTeamThreshold, msg.sender);
}
```

### Threshold Constraints
- **Maximum threshold**: `MAX_THRESHOLD = TOTAL_SUPPLY / 50` (2% of total supply)
- **Increase-only emergency**: Can only increase thresholds for security
- **Owner control**: Only owner can set initial thresholds
- **Admin emergency**: Admin can increase thresholds in emergencies

---

## Security and Access Controls

### Access Control Levels

1. **Owner Functions**
   ```solidity
   modifier onlyOwner() // From OpenZeppelin Ownable
   ```
   - Set team wallet address
   - Set initial thresholds
   - Update max transfer amounts

2. **Admin Functions**
   ```solidity
   modifier onlyAdmin() {
       require(msg.sender == adminWallet, "Not admin");
       _;
   }
   ```
   - Emergency threshold increases
   - Router management
   - Operational controls

### Security Measures

1. **Input Validation**
   ```solidity
   require(_teamWallet != address(0), "Zero address");
   require(_teamThreshold <= MAX_THRESHOLD, "Exceeds max threshold");
   ```

2. **Reentrancy Protection**
   ```solidity
   modifier swapping() {
       inSwap = true;
       _;
       inSwap = false;
   }
   ```

3. **Safe Transfer Methods**
   ```solidity
   payable(teamWallet).sendValue(teamShare);
   ```

4. **Threshold Bounds**
   - Minimum: 0 (no minimum enforced)
   - Maximum: 2% of total supply
   - Increase-only emergency adjustments

---

## Multi-Chain Support

### Polygon Network Configuration
```solidity
// QuickSwap V2 Router (Polygon)
address public constant QUICKSWAP_V2_ROUTER = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;

// QuickSwap V3 Router (Polygon)
address public constant QUICKSWAP_V3_ROUTER = 0xF5B509Bb0909A69B1c207e495F687a6C0eE0989e;

// WMATIC (Polygon's WETH equivalent)
address public constant WPOL = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
```

### Native Currency Distribution
- **Ethereum**: ETH distribution via `sendValue()`
- **Polygon**: WMATIC distribution via `sendValue()`
- **Cross-chain**: Router abstraction enables multi-chain deployment

### Router Flexibility
```solidity
// V2 Router (default)
IUniswapV2Router02 public router;

// V3 Router (optional)
IUniswapV3SwapRouter public v3Router;

// Router selection
bool public useV3Router = false;
```

---

## Router Integration

### Router Management
```solidity
function updateRouter(address _newRouter) external onlyAdmin {
    require(_newRouter != address(0), "Zero address");
    require(_newRouter != address(router), "Already set");
    
    address oldRouter = address(router);
    router = IUniswapV2Router02(_newRouter);
    
    // Update approvals
    _approve(address(this), oldRouter, 0);
    _approve(address(this), address(router), type(uint256).max);
    
    lastRouterUpdateTime = block.timestamp;
    routerUpdateCount++;
    
    emit RouterUpdated(oldRouter, _newRouter);
}
```

### V3 Router Setup
```solidity
function setupQuickSwapV3() external onlyAdmin {
    v3Router = IUniswapV3SwapRouter(QUICKSWAP_V3_ROUTER);
    emit V3RouterUpdated(address(0), QUICKSWAP_V3_ROUTER);
}

function toggleRouterVersion() external onlyAdmin {
    require(address(v3Router) != address(0), "V3 router not set");
    useV3Router = !useV3Router;
    emit RouterVersionToggled(useV3Router);
}
```

### Router Status Monitoring
```solidity
function getRouterConfig() external view returns (
    address v2Router,
    address v3RouterAddress,
    bool usingV3,
    uint256 lastUpdate,
    uint256 updateCount
) {
    return (
        address(router),
        address(v3Router),
        useV3Router,
        lastRouterUpdateTime,
        routerUpdateCount
    );
}
```

---

## Payment Flow Analysis

### Complete Payment Flow

1. **Transaction Execution**
   ```solidity
   function _transferWithFees(address from, address to, uint256 amount) internal returns (bool) {
       uint256 totalFee = (amount * TOTAL_FEE_PERCENTAGE) / FEE_DENOMINATOR;
       uint256 teamFee = (amount * BASE_TEAM_FEE) / FEE_DENOMINATOR;
       
       super._transfer(from, to, remaining);
       super._transfer(from, address(this), totalFee);
   }
   ```

2. **Threshold Monitoring**
   ```solidity
   if (swapEnabled && !inSwap && balanceOf(address(this)) >= swapThreshold) {
       _maybeSwapBack();
   }
   ```

3. **Swap Execution**
   ```solidity
   bool shouldSwapTeam = contractBalance >= teamSwapThreshold;
   if (shouldSwapTeam) {
       uint256 swapAmount = (contractBalance * totalFee) / TOTAL_FEE_PERCENTAGE;
       _swapBackV2(swapAmount); // or _swapBackV3(swapAmount)
   }
   ```

4. **Distribution**
   ```solidity
   uint256 teamShare = (ethBalance * BASE_TEAM_FEE) / totalFee;
   payable(teamWallet).sendValue(teamShare);
   ```

### Gas Cost Analysis

| Operation | Gas Cost | Frequency | Description |
|-----------|----------|-----------|-------------|
| Fee Collection | ~2,000 | Every transaction | Extract 1% team fee |
| Threshold Check | ~500 | Every transaction | Check if swap needed |
| Swap Execution | ~50,000 | Threshold reached | DEX swap to ETH/WMATIC |
| Distribution | ~2,000 | After swap | Send ETH to team wallet |

### Optimization Features
- **Batch processing**: Accumulates fees before swapping
- **Threshold-based**: Reduces frequent small swaps
- **Gas-efficient**: Uses optimized swap methods
- **Lazy evaluation**: Only swaps when necessary

---

## Admin Controls

### Team Wallet Management
```solidity
function setTeamWallet(address _teamWallet) external onlyOwner {
    require(_teamWallet != address(0), "Zero address");
    
    address oldWallet = teamWallet;
    teamWallet = _teamWallet;
    
    emit WalletUpdated("team", oldWallet, _teamWallet);
}
```

### Threshold Controls
```solidity
// Normal threshold setting
function setThresholds(uint256 _teamThreshold, uint256 _liquidityThreshold) external onlyOwner

// Emergency threshold increase
function emergencyIncreaseThresholds(uint256 _newTeamThreshold, uint256 _newLiquidityThreshold) external onlyAdmin
```

### Router Management
```solidity
// Update V2 router
function updateRouter(address _newRouter) external onlyAdmin

// Setup V3 router
function setupQuickSwapV3() external onlyAdmin

// Toggle between V2/V3
function toggleRouterVersion() external onlyAdmin
```

### Monitoring Functions
```solidity
function getSwapStatus() external view returns (
    bool enabled,
    uint256 teamThreshold,
    uint256 liquidityThresholdValue,
    uint256 contractBalance
)

function getRouterConfig() external view returns (
    address v2Router,
    address v3RouterAddress,
    bool usingV3,
    uint256 lastUpdate,
    uint256 updateCount
)
```

---

## Monitoring and Analytics

### Event System
```solidity
// Wallet management events
event WalletUpdated(string walletType, address indexed oldWallet, address indexed newWallet);

// Threshold management events
event ThresholdsUpdated(uint256 teamThreshold, uint256 liquidityThreshold);
event EmergencyThresholdUpdate(uint256 oldThreshold, uint256 newThreshold, address indexed by);

// Router management events
event RouterUpdated(address indexed oldRouter, address indexed newRouter);
event V3RouterUpdated(address indexed oldV3Router, address indexed newV3Router);
event RouterVersionToggled(bool useV3);
```

### Analytics Integration
Events can be used for:
- **Payment tracking**: Monitor team fee distributions
- **Threshold analysis**: Track threshold adjustments
- **Router performance**: Monitor swap success rates
- **Gas optimization**: Analyze swap frequency and costs

### Dashboard Metrics
- Total team fees collected
- Number of distributions made
- Average distribution size
- Threshold utilization rate
- Router performance metrics

---

## Risk Management

### Market Risk
1. **Slippage Risk**
   - **Mitigation**: Accepts any swap amount (no slippage protection)
   - **Impact**: May receive less ETH than expected in volatile markets
   - **Monitoring**: Track swap success rates and amounts

2. **Liquidity Risk**
   - **Mitigation**: Uses established DEX with high liquidity
   - **Impact**: Swaps may fail if insufficient liquidity
   - **Monitoring**: Monitor swap failure rates

### Technical Risk
1. **Router Risk**
   - **Mitigation**: Multi-router support and admin controls
   - **Impact**: Router issues may prevent swaps
   - **Monitoring**: Router health checks and fallback options

2. **Threshold Risk**
   - **Mitigation**: Configurable thresholds with bounds
   - **Impact**: Inappropriate thresholds may affect cash flow
   - **Monitoring**: Threshold utilization and adjustment frequency

### Security Risk
1. **Access Control Risk**
   - **Mitigation**: Owner-only wallet updates, admin role separation
   - **Impact**: Unauthorized wallet changes
   - **Monitoring**: Wallet change events and admin actions

2. **Reentrancy Risk**
   - **Mitigation**: `swapping` modifier protection
   - **Impact**: Potential for reentrancy attacks
   - **Monitoring**: Swap execution patterns

---

## Troubleshooting and Maintenance

### Common Issues

1. **No Team Payments**
   - **Cause**: Threshold not met, insufficient contract balance
   - **Solution**: Check `getSwapStatus()` for current balance and threshold
   - **Diagnostic**: `contractBalance < teamSwapThreshold`

2. **Failed Swaps**
   - **Cause**: Insufficient liquidity, router issues
   - **Solution**: Check router configuration and liquidity pools
   - **Diagnostic**: Monitor swap failure events

3. **High Gas Costs**
   - **Cause**: Low threshold causing frequent swaps
   - **Solution**: Increase `teamSwapThreshold`
   - **Diagnostic**: Monitor swap frequency and gas costs

4. **Incorrect Distribution**
   - **Cause**: Calculation errors or precision loss
   - **Solution**: Verify fee calculations and distribution logic
   - **Diagnostic**: Check event logs for distribution amounts

### Maintenance Procedures

1. **Regular Monitoring**
   ```solidity
   // Check swap status
   (bool enabled, uint256 teamThreshold, , uint256 contractBalance) = getSwapStatus();
   
   // Monitor router health
   (address router, , , uint256 lastUpdate, ) = getRouterConfig();
   ```

2. **Threshold Optimization**
   ```solidity
   // Adjust based on transaction volume
   if (volume > high_threshold) {
       setThresholds(new_team_threshold, new_liquidity_threshold);
   }
   ```

3. **Router Management**
   ```solidity
   // Update router if needed
   if (router_issues_detected) {
       updateRouter(new_router_address);
   }
   ```

### Best Practices

1. **Threshold Management**
   - Set thresholds based on expected transaction volume
   - Monitor gas costs and adjust accordingly
   - Consider market conditions and volatility

2. **Wallet Security**
   - Use multi-signature wallets for team funds
   - Regularly audit wallet permissions
   - Monitor for unauthorized changes

3. **Router Strategy**
   - Maintain backup router configurations
   - Monitor router performance and reliability
   - Test router updates on testnet first

4. **Monitoring Strategy**
   - Track payment distribution metrics
   - Monitor swap success rates
   - Alert on unusual activity patterns

---

## Conclusion

The SHAMBA LUV team payment system represents a sophisticated implementation of automatic fee collection and distribution that provides sustainable funding for project development and marketing activities. The system's key strengths include:

### Technical Excellence
- **Automatic operation**: No manual intervention required
- **Gas optimization**: Threshold-based processing reduces costs
- **Multi-router support**: Flexibility for different DEX protocols
- **Security controls**: Comprehensive access control and validation

### Operational Benefits
- **Predictable revenue**: Consistent 1% fee collection
- **Immediate conversion**: Automatic token-to-native conversion
- **Transparent tracking**: Comprehensive event system
- **Flexible management**: Configurable thresholds and wallets

### Risk Management
- **Market protection**: Accepts any swap amount to ensure completion
- **Access control**: Owner-only critical functions
- **Emergency controls**: Admin ability to adjust thresholds
- **Monitoring capabilities**: Full visibility into system operation

The system is designed to provide reliable, automated funding for team operations while maintaining security, efficiency, and transparency standards expected in modern DeFi applications. The combination of automatic collection, intelligent threshold management, and robust distribution mechanisms creates a sustainable foundation for project development and community growth. 
