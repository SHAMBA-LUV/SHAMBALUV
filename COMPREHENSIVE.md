# SHAMBA LUV Token - Comprehensive Documentation

## 📋 Overview

**SHAMBA LUV** is a multi-chain reflection token built for Ethereum Virtual Machine (EVM) with advanced security features, MEV protection, and comprehensive governance mechanisms. The token implements a reflections based fee structure rewarding holders while supporting project development and liquidity growth. SHAMBA LUV grows when you hold LUV. Hold LUV to earn LUV. fee free sharing of LUV. 5% fee on buy and sell. v2 default for trading with v3 upgrade. Designed for Agglayer compatiabilty for cross-chain tokenomics.

## 🏗️ Contract Architecture

### **Core Components**

- **ERC20 Standard** - Full ERC20 compliance with enhanced functionality
- **Ownable Pattern** - Secure ownership management with timelock protection
- **ReentrancyGuard** - Protection against reentrancy attacks
- **Multi-Router Support** - Uniswap V2/V3 compatibility for multi-chain deployment
- **Advanced Reflection System** - Gas-optimized holder reward distribution

### **Smart Contract Details**

```solidity
Contract Name: SHAMBALUV
Token Symbol: LUV
Decimals: 18
Total Supply: 100,000,000,000,000,000 LUV (100 Quadrillion)
Network: EVM-Compatible (Polygon, Ethereum, BSC, etc.)
```

## 💰 Token Economics

### **Supply Distribution**

| Category | Amount | Percentage | Purpose |
|----------|--------|------------|---------|
| **Total Supply** | 100 Quadrillion | 100% | Maximum token supply |
| **Initial Distribution** | 100 Quadrillion | 100% | Minted to owner |
| **Circulating Supply** | Variable | Dynamic | Based on trading activity |

### **Fee Structure (5% Total)**

| Fee Type | Percentage | Purpose | Recipient |
|----------|------------|---------|-----------|
| **Reflection Fee** | 3% | Holder rewards | All token holders |
| **Liquidity Fee** | 1% | Pool growth | Liquidity wallet |
| **Team Fee** | 1% | Project development | Team wallet |
| **Total Fees** | 5% | Transaction costs | Distributed automatically |

### **Fee Exemptions**

- **Wallet-to-Wallet Transfers** - Fee-free when enabled
- **Owner & Contract** - Exempt from max transfer limits
- **Liquidity Wallet** - Exempt from reflection fees
- **Admin Wallet** - Exempt from max transfer limits

## 🔒 Security Features

### **Access Control System**

#### **Owner Functions**
```solidity
// Critical settings (timelock protected)
setTimelockDelay()           // Set general timelock delay
setMaxSlippage()             // Set maximum slippage tolerance
setMaxTransferPercent()      // Set max transfer percentage
setMaxTransferAmount()       // Set max transfer amount
setTeamWallet()              // Update team wallet address
setLiquidityWallet()         // Update liquidity wallet address

// Exemption management
setFeeExemption()            // Set fee exemption status
setMaxTransferExemption()    // Set max transfer exemption
setReflectionExemption()     // Set reflection exemption

// Reflection management
setReflectionThreshold()     // Set reflection batch threshold
```

#### **Admin Functions**
```solidity
// Router management (timelock protected)
updateRouter()               // Update V2 router address
setV3Router()                // Set V3 router address
setupQuickSwapV3()           // Configure QuickSwap V3
toggleRouterVersion()        // Switch between V2/V3

// Admin management (timelock protected)
changeAdminByAdmin()         // Transfer admin role
renounceAdminRole()          // Permanently renounce admin

// Router timelock management
setRouterTimelockDelay()     // Set router-specific timelock

// Emergency functions
emergencyIncreaseThresholds() // Increase swap thresholds
```

### **Timelock Protection**

#### **General Timelock (Owner Functions)**
- **Default Delay**: 24 hours
- **Range**: 1 hour to 1000 years
- **Protected Functions**: Critical settings, wallet updates, fee management

#### **Router Timelock (Admin Functions)**
- **Default Delay**: 24 hours
- **Range**: 1 hour to 1000 years
- **Protected Functions**: Router updates, V3 configuration, admin changes

#### **Timelock Process**
1. **Proposal Phase** - Function call creates timelock proposal
2. **Waiting Period** - Must wait for configured delay duration
3. **Execution Phase** - Same function call executes the change
4. **Verification** - Change takes effect immediately

### **MEV Protection**

#### **Slippage Protection**
```solidity
// Configurable slippage limits
DEFAULT_SLIPPAGE = 500;      // 5% default
MAX_SLIPPAGE = 2000;         // 20% maximum

// Automatic slippage calculation
function _calculateMinimumOutput(uint256 amount, uint256 slippage)
```

#### **Protection Mechanisms**
- **V2 Router Protection** - `swapExactTokensForETHSupportingFeeOnTransferTokens`
- **V3 Router Protection** - `exactInputSingle` with `amountOutMinimum`
- **Real-time Validation** - Slippage checks during execution
- **Event Logging** - `SlippageProtectionUsed` events for transparency

### **Transfer Limits**

#### **Maximum Transfer Controls**
- **Default Limit**: 1% of total supply
- **Configurable**: Owner can adjust within bounds
- **Exemptions**: Owner, contract, liquidity wallet, admin wallet

#### **Anti-Whale Protection**
- **Large Transfer Prevention** - Prevents market manipulation
- **Gradual Distribution** - Encourages fair token distribution
- **Community Protection** - Safeguards against dumping

## 💎 Reflection System

### **Advanced Reflection Mechanics**

#### **Gas-Optimized Distribution**
```solidity
// Batch processing threshold
REFLECTION_BATCH_THRESHOLD = 1_000_000_000_000 * 1e18; // 1 trillion

// Efficient index calculation
reflectionIndex += (reflectionFees * REFLECTION_DENOMINATOR) / totalSupply;
```

#### **Holder Reward Calculation**
```solidity
// Individual reflection balance
function getReflectionBalance(address account) public view returns (uint256) {
    return (balanceOf(account) * reflectionIndex) / REFLECTION_DENOMINATOR;
}
```

#### **Automatic Distribution**
- **Real-time Updates** - Reflection index updates with each transaction
- **Gas Efficiency** - Batch processing for large volumes
- **Fair Distribution** - Proportional to token holdings
- **Transparent Tracking** - Public reflection statistics

### **Reflection Statistics**

#### **Global Metrics**
```solidity
function getReflectionStats() external view returns (
    uint256 totalCollected,      // Total fees collected
    uint256 totalDistributed,    // Total distributed to holders
    uint256 currentIndex,        // Current reflection index
    uint256 totalHolders,        // Number of holders
    uint256 averageReflection,   // Average reflection per holder
    uint256 lastDistribution     // Last distribution timestamp
);
```

#### **Individual Metrics**
```solidity
function getHolderReflectionInfo(address holder) external view returns (
    uint256 tokenBalance,        // Current token balance
    uint256 reflectionBalance,   // Accumulated reflections
    uint256 totalEarned,         // Total reflections earned
    uint256 lastUpdate           // Last reflection update
);
```

## 🔄 Multi-Router Support

### **Uniswap V2 Integration**

#### **Router Management**
```solidity
// V2 router interface
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

#### **V2 Features**
- **Standard DEX Integration** - Compatible with all V2 forks
- **Slippage Protection** - Configurable minimum output amounts
- **Gas Optimization** - Efficient swap execution
- **Multi-Chain Support** - Deployable on any EVM chain

### **Uniswap V3 Integration**

#### **Router Management**
```solidity
// V3 router interface
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
}
```

#### **V3 Features**
- **Advanced Routing** - Optimal path finding
- **Concentrated Liquidity** - Better price efficiency
- **Multiple Fee Tiers** - Flexible fee structures
- **Enhanced MEV Protection** - Superior slippage control

### **Router Configuration**

#### **Dynamic Router Switching**
```solidity
// Toggle between V2 and V3
function toggleRouterVersion() external onlyAdmin timelock(routerTimelockDelay)

// Get current configuration
function getRouterConfig() external view returns (
    address v2Router,           // Current V2 router
    address v3RouterAddress,    // Current V3 router
    bool usingV3,               // Active router version
    uint256 lastUpdate,         // Last router update
    uint256 updateCount         // Total update count
);
```

#### **QuickSwap V3 Integration**
```solidity
// Polygon QuickSwap V3 router
QUICKSWAP_V3_ROUTER = 0xf6ad3CcF71Abb3E12beCf6b3D2a1C8C49381baa7;

// Quick setup function
function setupQuickSwapV3() external onlyAdmin timelock(routerTimelockDelay)
```

## 🛡️ Advanced Security

### **Reentrancy Protection**

#### **Guard Implementation**
```solidity
// Inherits OpenZeppelin ReentrancyGuard
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

// Automatic protection on all external functions
modifier swapping() {
    inSwap = true;
    _;
    inSwap = false;
}
```

#### **Protected Functions**
- **Transfer Operations** - All token transfers protected
- **Swap Functions** - DEX interactions secured
- **Fee Distribution** - Reflection calculations protected
- **Admin Functions** - Critical operations secured

### **Access Control Validation**

#### **Role-Based Permissions**
```solidity
// Owner-only functions
modifier onlyOwner() // OpenZeppelin Ownable

// Admin-only functions
modifier onlyAdmin() {
    require(msg.sender == adminWallet, "Not admin");
    _;
}
```

#### **Function Protection**
- **Critical Settings** - Owner-only with timelock
- **Router Management** - Admin-only with timelock
- **Emergency Functions** - Admin-only for quick response
- **View Functions** - Public access for transparency

### **Bounds Checking**

#### **Timelock Bounds**
```solidity
MIN_TIMELOCK_DELAY = 1 hours;           // Minimum delay
MAX_TIMELOCK_DELAY = 1000 * 365 days;   // Maximum delay (1000 years)
DEFAULT_TIMELOCK_DELAY = 24 hours;      // Default delay
```

#### **Slippage Bounds**
```solidity
DEFAULT_SLIPPAGE = 500;                 // 5% default (500 basis points)
MAX_SLIPPAGE = 2000;                    // 20% maximum (2000 basis points)
```

#### **Transfer Bounds**
```solidity
maxTransferPercent = 100;               // 1% of total supply
MAX_THRESHOLD = TOTAL_SUPPLY / 50;      // 2% maximum threshold
```

## 📊 Performance Optimization

### **Gas Efficiency Features**

#### **Batch Processing**
```solidity
// Reflection batch threshold
REFLECTION_BATCH_THRESHOLD = 1_000_000_000_000 * 1e18;

// Local total supply tracking
uint256 private _localTotalSupply;
```

#### **Optimized Calculations**
- **Local Variables** - Reduced storage reads
- **Batch Updates** - Efficient reflection distribution
- **Minimal Storage** - Optimized data structures
- **Efficient Loops** - Gas-conscious iteration

### **Memory Management**

#### **Efficient Data Structures**
```solidity
// Mapping for timelock proposals
mapping(bytes32 => uint256) public timelockProposals;

// Boolean flags for exemptions
mapping(address => bool) public isExcludedFromFee;
mapping(address => bool) public isExcludedFromMaxTransfer;
mapping(address => bool) public isExcludedFromReflection;
```

#### **Storage Optimization**
- **Packed Structs** - Efficient data packing
- **Minimal State Variables** - Reduced storage costs
- **Event-Based Logging** - Cost-effective tracking
- **View Functions** - Free data access

## 🔍 Monitoring & Analytics

### **Event System**

#### **Security Events**
```solidity
event TimelockDelayUpdated(uint256 oldDelay, uint256 newDelay, address indexed by);
event RouterTimelockDelayUpdated(uint256 oldDelay, uint256 newDelay, address indexed by);
event TimelockProposed(bytes32 indexed proposalId, uint256 executionTime);
event TimelockExecuted(bytes32 indexed proposalId, address indexed executor);
event SlippageProtectionUsed(uint256 amountIn, uint256 amountOutMin, uint256 actualAmountOut, string routerType);
```

#### **Router Events**
```solidity
event RouterUpdated(address indexed oldRouter, address indexed newRouter);
event V3RouterUpdated(address indexed oldV3Router, address indexed newV3Router);
event RouterVersionToggled(bool useV3);
```

#### **Fee Events**
```solidity
event FeeExemptionUpdated(address indexed account, bool status);
event MaxTransferExemptionUpdated(address indexed account, bool status);
event ReflectionExemptionUpdated(address indexed account, bool status);
event WalletToWalletFeeExemptTransfer(address indexed from, address indexed to, uint256 amount);
```

#### **Reflection Events**
```solidity
event ReflectionDistributed(address indexed holder, uint256 amount);
event ReflectionBatchProcessed(uint256 totalFees, uint256 newIndex);
event ReflectionThresholdUpdated(uint256 oldThreshold, uint256 newThreshold);
```

### **Analytics Functions**

#### **Contract Statistics**
```solidity
function getContractStats() external view returns (
    uint256 totalSupply,           // Total token supply
    uint256 circulatingSupply,     // Circulating tokens
    uint256 totalFeesCollected,    // Total fees collected
    uint256 totalReflections,      // Total reflections distributed
    uint256 activeHolders,         // Number of active holders
    uint256 contractBalance        // Contract token balance
);
```

#### **Security Status**
```solidity
function getSecuritySettings() external view returns (
    uint256 currentSlippage,       // Current slippage setting
    uint256 maxAllowedSlippage,    // Maximum allowed slippage
    uint256 minimumFee,            // Minimum fee threshold
    uint256 currentTimelockDelay,  // Current timelock delay
    uint256 lastCriticalUpdate     // Last critical update time
);
```

#### **Router Status**
```solidity
function getRouterStatus() external view returns (
    address routerAddress,         // Current router address
    uint256 lastUpdate,            // Last router update
    uint256 updateCount            // Total update count
);
```

## 🚀 Deployment Guide

### **Contract Deployment**

#### **Constructor Parameters**
```solidity
constructor(
    address _teamWallet,      // Team fee collection wallet
    address _liquidityWallet, // Liquidity fee collection wallet
    address _router           // Initial router address
)
```

#### **Deployment Steps**
1. **Deploy Contract** - Use constructor with wallet addresses
2. **Set Initial Exemptions** - Configure fee exemptions
3. **Transfer Ownership** - Transfer to admin wallet
4. **Configure Router** - Set up V2/V3 router addresses
5. **Set Timelock Delays** - Configure security delays
6. **Verify Contract** - Verify on block explorer

### **Multi-Chain Deployment**

#### **Supported Networks**
- **Polygon** - Primary deployment with QuickSwap
- **Ethereum** - Mainnet with Uniswap
- **BSC** - Binance Smart Chain with PancakeSwap
- **Arbitrum** - Layer 2 with SushiSwap
- **Optimism** - Layer 2 with Uniswap V3

#### **Network-Specific Configuration**
```solidity
// Polygon QuickSwap V2
QUICKSWAP_V2_ROUTER = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;

// Polygon QuickSwap V3
QUICKSWAP_V3_ROUTER = 0xf6ad3CcF71Abb3E12beCf6b3D2a1C8C49381baa7;

// Ethereum Uniswap V2
UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

// BSC PancakeSwap V2
PANCAKESWAP_V2_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
```

### **Post-Deployment Configuration**

#### **Initial Setup**
```solidity
// Set up V3 router
adminWallet.setupQuickSwapV3();

// Configure timelock delays
owner.setTimelockDelay(24 hours);
adminWallet.setRouterTimelockDelay(12 hours);

// Set initial exemptions
owner.setFeeExemption(owner, true);
owner.setMaxTransferExemption(owner, true);
owner.setReflectionExemption(liquidityWallet, true);
```

#### **Security Configuration**
```solidity
// Set slippage protection
owner.setMaxSlippage(500); // 5%

// Configure transfer limits
owner.setMaxTransferPercent(100); // 1%

// Set swap thresholds
adminWallet.emergencyIncreaseThresholds(
    1_000_000_000_000 * 1e18, // 1 trillion team threshold
    2_000_000_000_000 * 1e18  // 2 trillion liquidity threshold
);
```

## 📈 Use Cases & Applications

### **DeFi Integration**

#### **Yield Farming**
- **Reflection Rewards** - Earn tokens by holding
- **Liquidity Provision** - Provide liquidity for additional rewards
- **Staking Integration** - Compatible with staking protocols

#### **Trading**
- **DEX Trading** - Trade on any supported DEX
- **Cross-Chain Trading** - Multi-chain trading capabilities
- **MEV Protection** - Protected against sandwich attacks

### **Governance & DAO**

#### **Timelock Governance**
- **Proposal System** - Timelock-based proposal execution
- **Community Voting** - Transparent governance process
- **Emergency Response** - Quick response to critical issues

#### **Access Control**
- **Role-Based Permissions** - Clear role separation
- **Multi-Signature Support** - Compatible with multi-sig wallets
- **Upgradeable Architecture** - Future-proof design

### **Enterprise Applications**

#### **Payment Systems**
- **Fee-Free Transfers** - Wallet-to-wallet fee exemption
- **Bulk Transfers** - Efficient batch processing
- **Cross-Chain Payments** - Multi-chain payment support

#### **Loyalty Programs**
- **Reflection Rewards** - Automatic holder rewards
- **Tiered Benefits** - Based on token holdings
- **Transparent Tracking** - Public reward statistics

## 🔮 Future Enhancements

### **Planned Features**

#### **Advanced Routing**
- **Multi-Path Routing** - Optimal trade path finding
- **Cross-Chain Routing** - Seamless cross-chain swaps
- **Aggregator Integration** - Best price aggregation

#### **Enhanced Security**
- **Multi-Signature Timelock** - Multi-sig timelock execution
- **Advanced MEV Protection** - Enhanced sandwich attack prevention
- **Audit Trail** - Comprehensive transaction logging

#### **Performance Improvements**
- **Layer 2 Optimization** - L2-specific optimizations
- **Gasless Transactions** - Meta-transaction support
- **Batch Processing** - Enhanced batch operations

### **Scalability Features**

#### **Sharding Support**
- **Cross-Shard Transfers** - Shard-compatible transfers
- **Scalable Reflections** - Efficient large-scale distribution
- **Parallel Processing** - Concurrent transaction processing

#### **Interoperability**
- **Bridge Integration** - Cross-chain bridge support
- **Standard Compliance** - ERC-20, ERC-721, ERC-1155 compatibility
- **Protocol Integration** - DeFi protocol compatibility

## 📚 Technical References

### **Smart Contract Standards**

#### **ERC-20 Compliance**
- **Transfer Function** - Standard ERC-20 transfer
- **Approve Function** - Standard approval mechanism
- **Allowance System** - Standard allowance tracking
- **Event Emissions** - Standard transfer events

#### **Security Standards**
- **OpenZeppelin Contracts** - Industry-standard security
- **ReentrancyGuard** - Reentrancy attack protection
- **Ownable Pattern** - Secure ownership management
- **Timelock Pattern** - Governance delay mechanism

### **Integration Examples**

#### **Web3 Integration**
```javascript
// Connect to contract
const contract = new web3.eth.Contract(SHAMBALUV_ABI, CONTRACT_ADDRESS);

// Get reflection balance
const reflectionBalance = await contract.methods
    .getReflectionBalance(userAddress)
    .call();

// Get contract statistics
const stats = await contract.methods.getContractStats().call();
```

#### **DEX Integration**
```solidity
// Swap tokens for ETH
router.swapExactTokensForETHSupportingFeeOnTransferTokens(
    amountIn,
    amountOutMin,
    path,
    to,
    deadline
);
```

## 🎯 Conclusion

The SHAMBA LUV token represents a comprehensive solution for modern DeFi applications, combining advanced security features, efficient reflection mechanics, and flexible multi-chain deployment capabilities. With its robust timelock governance, MEV protection, and gas-optimized architecture, it provides a solid foundation for sustainable token economics and community-driven development.

The contract's modular design allows for easy customization and future enhancements while maintaining backward compatibility and security standards. Whether deployed on Polygon, Ethereum, or any other EVM-compatible chain, SHAMBA LUV provides the tools and infrastructure needed for successful token projects in the evolving DeFi landscape. 
