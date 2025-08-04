# 🔒 Variable Timelock System - LUV Contract

## 🎯 **Overview**

The LUV contract now features a **variable timelock system** that allows the owner to adjust the timelock delay for critical functions. This provides flexibility while maintaining security.

## ⚙️ **Timelock Configuration**

### **Constants (Fixed)**
```solidity
uint256 public constant MIN_TIMELOCK_DELAY = 1 hours;     // Minimum 1 hour
uint256 public constant MAX_TIMELOCK_DELAY = 30 days;     // Maximum 30 days  
uint256 public constant DEFAULT_TIMELOCK_DELAY = 24 hours; // Default 24 hours
```

### **State Variable (Modifiable)**
```solidity
uint256 public timelockDelay = DEFAULT_TIMELOCK_DELAY; // Current delay (24 hours default)
```

## 🛠️ **Timelock Management Functions**

### **1. Set Timelock Delay**
```solidity
function setTimelockDelay(uint256 _newDelay) external onlyOwner
```

**Parameters:**
- `_newDelay`: New delay in seconds

**Constraints:**
- Minimum: 1 hour (3,600 seconds)
- Maximum: 30 days (2,592,000 seconds)

**Security Features:**
- ✅ **NOT timelocked** - Allows emergency adjustments
- ✅ **Owner only** - Only contract owner can modify
- ✅ **Bounds checking** - Prevents extreme values
- ✅ **Event emission** - Transparent changes

**Example Usage:**
```javascript
// Set to 12 hours
await contract.setTimelockDelay(12 * 60 * 60); // 43,200 seconds

// Set to 48 hours  
await contract.setTimelockDelay(48 * 60 * 60); // 172,800 seconds

// Set to 7 days
await contract.setTimelockDelay(7 * 24 * 60 * 60); // 604,800 seconds
```

### **2. Get Timelock Information**
```solidity
function getTimelockDelayInfo() external view returns (
    uint256 currentDelay,
    uint256 minDelay,
    uint256 maxDelay,
    uint256 defaultDelay
)
```

**Returns:**
- `currentDelay`: Current timelock delay in seconds
- `minDelay`: Minimum allowed delay (1 hour)
- `maxDelay`: Maximum allowed delay (30 days)
- `defaultDelay`: Default delay value (24 hours)

**Example Usage:**
```javascript
const [current, min, max, default] = await contract.getTimelockDelayInfo();
console.log(`Current: ${current} seconds (${current/3600} hours)`);
console.log(`Min: ${min} seconds (${min/3600} hours)`);
console.log(`Max: ${max} seconds (${max/86400} days)`);
console.log(`Default: ${default} seconds (${default/3600} hours)`);
```

## 🔄 **Functions Using Variable Timelock**

All critical functions now use the variable `timelockDelay` instead of the fixed constant:

1. **`setMaxSlippage()`** - Change maximum slippage
2. **`setMaxTransferPercent()`** - Change max transfer percentage
3. **`setMaxTransferAmount()`** - Change absolute max transfer amount
4. **`setTeamWallet()`** - Change team fee collection wallet
5. **`setLiquidityWallet()`** - Change liquidity fee collection wallet

## 📊 **Timelock Delay Examples**

### **Common Delay Settings**

| Delay | Seconds | Use Case |
|-------|---------|----------|
| 1 hour | 3,600 | Emergency adjustments |
| 6 hours | 21,600 | Quick changes |
| 12 hours | 43,200 | Standard business hours |
| 24 hours | 86,400 | **Default** - Full day review |
| 48 hours | 172,800 | Weekend coverage |
| 7 days | 604,800 | Extended review period |
| 14 days | 1,209,600 | Major changes |
| 30 days | 2,592,000 | Maximum security |

### **JavaScript Helper Functions**
```javascript
// Convert hours to seconds
function hoursToSeconds(hours) {
    return hours * 60 * 60;
}

// Convert days to seconds  
function daysToSeconds(days) {
    return days * 24 * 60 * 60;
}

// Set timelock to specific hours
async function setTimelockHours(hours) {
    const seconds = hoursToSeconds(hours);
    await contract.setTimelockDelay(seconds);
}

// Set timelock to specific days
async function setTimelockDays(days) {
    const seconds = daysToSeconds(days);
    await contract.setTimelockDelay(seconds);
}
```

## 🚨 **Security Considerations**

### **Advantages of Variable Timelock**
1. **Flexibility** - Adjust delay based on circumstances
2. **Emergency Response** - Reduce delay for urgent changes
3. **Enhanced Security** - Increase delay for major changes
4. **Community Trust** - Transparent delay adjustments

### **Risk Mitigation**
1. **Bounds Protection** - Cannot set extreme values
2. **Owner Only** - Restricted access
3. **Event Logging** - All changes are recorded
4. **No Timelock on Delay** - Prevents deadlock scenarios

### **Best Practices**
1. **Default Setting** - Start with 24 hours
2. **Gradual Changes** - Don't make extreme adjustments
3. **Community Communication** - Announce delay changes
4. **Documentation** - Keep records of changes

## 📈 **Monitoring and Events**

### **Timelock Delay Events**
```solidity
event TimelockDelayUpdated(uint256 oldDelay, uint256 newDelay, address indexed by);
```

**Event Parameters:**
- `oldDelay`: Previous timelock delay
- `newDelay`: New timelock delay
- `by`: Address that made the change

### **Security Settings Function**
```solidity
function getSecuritySettings() external view returns (
    uint256 currentSlippage,
    uint256 maxAllowedSlippage,
    uint256 minimumFee,
    uint256 currentTimelockDelay,  // Current delay
    uint256 lastCriticalUpdateTime
)
```

## 🎯 **Use Cases**

### **Scenario 1: Emergency Response**
```javascript
// Reduce delay for urgent security fix
await contract.setTimelockDelay(hoursToSeconds(1)); // 1 hour
// Make critical change
await contract.setTeamWallet(newSecureWallet);
// Restore normal delay
await contract.setTimelockDelay(hoursToSeconds(24)); // 24 hours
```

### **Scenario 2: Major Protocol Changes**
```javascript
// Increase delay for major changes
await contract.setTimelockDelay(daysToSeconds(7)); // 7 days
// Propose major change
await contract.setMaxTransferPercent(200); // 2% max transfer
// Community has 7 days to review
```

### **Scenario 3: Normal Operations**
```javascript
// Standard 24-hour delay
await contract.setTimelockDelay(hoursToSeconds(24));
// Regular administrative changes
await contract.setLiquidityWallet(newLiquidityWallet);
```

## ✅ **Summary**

The variable timelock system provides:

- ✅ **Flexible delays** from 1 hour to 30 days
- ✅ **Security bounds** prevent extreme values
- ✅ **Emergency capability** for urgent changes
- ✅ **Transparency** through events and monitoring
- ✅ **Owner control** with proper restrictions
- ✅ **Backward compatibility** with existing functions

**The timelock delay is now a configurable parameter that can be adjusted based on the specific needs and circumstances of the protocol!** 🔧 
