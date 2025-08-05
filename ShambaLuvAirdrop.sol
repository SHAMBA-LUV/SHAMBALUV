// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title ShambaLuvAirdrop
 * @dev Enhanced airdrop contract for SHAMBA LUV token with ETH and ERC20 support
 * @notice Automatically gives tokens to new users who connect their wallet
 * @notice Includes emergency functions and comprehensive safety features
 */
contract ShambaLuvAirdrop is Ownable, ReentrancyGuard, Pausable {
    using Address for address payable;

    IERC20 public immutable shambaLuvToken;
    
    // Airdrop amount per user (1 trillion tokens with 18 decimals)
    uint256 public airdropAmount = 1_000_000_000_000 * 1e18;
    
    // Track who has already claimed
    mapping(address => bool) public hasClaimed;
    
    // Custom airdrop amounts for future incentives
    mapping(address => uint256) public customAirdropAmounts;
    
    // Stats
    uint256 public totalClaimed;
    uint256 public totalRecipients;
    
    // Rate limiting
    uint256 public maxClaimsPerBlock = 10;
    uint256 public currentBlockClaims;
    uint256 public lastClaimBlock;
    
    // Emergency controls
    bool public emergencyMode = false;
    uint256 public maxTotalClaims = 3000; // Maximum number of total claims allowed
    
    // Events
    event AirdropClaimed(address indexed recipient, uint256 amount);
    event AirdropAmountUpdated(uint256 oldAmount, uint256 newAmount);
    event CustomAirdropAmountsSet(address[] recipients, uint256[] amounts);
    event CustomAirdropAmountsRemoved(address[] recipients);
    event TokensWithdrawn(address indexed owner, uint256 amount);
    event ETHReceived(address indexed sender, uint256 amount);
    event ETHWithdrawn(address indexed owner, uint256 amount);
    event ERC20Withdrawn(address indexed token, address indexed owner, uint256 amount);
    event EmergencyModeToggled(bool enabled);
    event MaxClaimsUpdated(uint256 oldMax, uint256 newMax);
    event MaxTotalClaimsUpdated(uint256 oldMax, uint256 newMax);
    event RateLimitReset(uint256 blockNumber);
    
    constructor(address _shambaLuvToken) {
        require(_shambaLuvToken != address(0), "Invalid token address");
        shambaLuvToken = IERC20(_shambaLuvToken);
    }
    
    /**
     * @dev Receive ETH function
     */
    receive() external payable {
        emit ETHReceived(msg.sender, msg.value);
    }
    
    /**
     * @dev Fallback function
     */
    fallback() external payable {
        emit ETHReceived(msg.sender, msg.value);
    }
    
    /**
     * @dev Claim airdrop tokens (one-time per address)
     * @dev Includes rate limiting and emergency mode checks
     * @dev Supports custom amounts for future incentives
     */
    function claimAirdrop() external nonReentrant whenNotPaused {
        require(!emergencyMode, "Contract in emergency mode");
        require(!hasClaimed[msg.sender], "Already claimed");
        require(totalRecipients < maxTotalClaims, "Max total claims reached");
        
        // Determine airdrop amount (custom or default)
        uint256 claimAmount = customAirdropAmounts[msg.sender] > 0 
            ? customAirdropAmounts[msg.sender] 
            : airdropAmount;
        
        require(claimAmount > 0, "No airdrop amount available");
        
        // Rate limiting check
        if (block.number == lastClaimBlock) {
            require(currentBlockClaims < maxClaimsPerBlock, "Rate limit exceeded");
            currentBlockClaims++;
        } else {
            lastClaimBlock = block.number;
            currentBlockClaims = 1;
        }
        
        // Check contract has enough tokens
        uint256 contractBalance = shambaLuvToken.balanceOf(address(this));
        require(contractBalance >= claimAmount, "Insufficient tokens in contract");
        
        // Mark as claimed
        hasClaimed[msg.sender] = true;
        totalClaimed += claimAmount;
        totalRecipients++;
        
        // Clear custom amount if it was used
        if (customAirdropAmounts[msg.sender] > 0) {
            delete customAirdropAmounts[msg.sender];
        }
        
        // Transfer tokens
        require(shambaLuvToken.transfer(msg.sender, claimAmount), "Transfer failed");
        
        emit AirdropClaimed(msg.sender, claimAmount);
    }
    
    /**
     * @dev Check if an address has already claimed
     */
    function hasUserClaimed(address user) external view returns (bool) {
        return hasClaimed[user];
    }
    
    /**
     * @dev Get airdrop stats
     */
    function getAirdropStats() external view returns (
        uint256 _airdropAmount,
        uint256 _totalClaimed,
        uint256 _totalRecipients,
        uint256 _contractBalance,
        uint256 _contractETHBalance,
        bool _emergencyMode,
        uint256 _maxTotalClaims,
        uint256 _remainingClaims
    ) {
        return (
            airdropAmount,
            totalClaimed,
            totalRecipients,
            shambaLuvToken.balanceOf(address(this)),
            address(this).balance,
            emergencyMode,
            maxTotalClaims,
            maxTotalClaims > totalRecipients ? maxTotalClaims - totalRecipients : 0
        );
    }
    
    /**
     * @dev Get rate limiting stats
     */
    function getRateLimitStats() external view returns (
        uint256 _maxClaimsPerBlock,
        uint256 _currentBlockClaims,
        uint256 _lastClaimBlock,
        bool _rateLimitActive
    ) {
        return (
            maxClaimsPerBlock,
            block.number == lastClaimBlock ? currentBlockClaims : 0,
            lastClaimBlock,
            block.number == lastClaimBlock && currentBlockClaims >= maxClaimsPerBlock
        );
    }
    
    /**
     * @dev Owner can update airdrop amount
     */
    function setAirdropAmount(uint256 _newAmount) external onlyOwner {
        require(_newAmount > 0, "Airdrop amount must be greater than 0");
        uint256 oldAmount = airdropAmount;
        airdropAmount = _newAmount;
        emit AirdropAmountUpdated(oldAmount, _newAmount);
    }
    
    /**
     * @dev Owner can set different airdrop amounts for specific addresses (future incentives)
     * @param _recipients Array of addresses to set custom amounts for
     * @param _amounts Array of custom amounts for each recipient
     */
    function setCustomAirdropAmounts(
        address[] calldata _recipients,
        uint256[] calldata _amounts
    ) external onlyOwner {
        require(_recipients.length == _amounts.length, "Arrays length mismatch");
        require(_recipients.length > 0, "Empty arrays not allowed");
        require(_recipients.length <= 100, "Max 100 recipients per batch");
        
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid recipient address");
            require(_amounts[i] > 0, "Amount must be greater than 0");
            require(!hasClaimed[_recipients[i]], "Recipient already claimed");
            
            // Set custom amount for this recipient
            customAirdropAmounts[_recipients[i]] = _amounts[i];
        }
        
        emit CustomAirdropAmountsSet(_recipients, _amounts);
    }
    
    /**
     * @dev Owner can remove custom airdrop amounts for specific addresses
     * @param _recipients Array of addresses to remove custom amounts for
     */
    function removeCustomAirdropAmounts(address[] calldata _recipients) external onlyOwner {
        require(_recipients.length > 0, "Empty array not allowed");
        require(_recipients.length <= 100, "Max 100 recipients per batch");
        
        for (uint256 i = 0; i < _recipients.length; i++) {
            delete customAirdropAmounts[_recipients[i]];
        }
        
        emit CustomAirdropAmountsRemoved(_recipients);
    }
    
    /**
     * @dev Get custom airdrop amount for a specific address
     * @param _recipient Address to check
     * @return Custom amount if set, otherwise 0
     */
    function getCustomAirdropAmount(address _recipient) external view returns (uint256) {
        return customAirdropAmounts[_recipient];
    }
    
    /**
     * @dev Check if an address has a custom airdrop amount
     * @param _recipient Address to check
     * @return True if custom amount is set
     */
    function hasCustomAirdropAmount(address _recipient) external view returns (bool) {
        return customAirdropAmounts[_recipient] > 0;
    }
    
    /**
     * @dev Get available airdrop amount for a specific address
     * @param _recipient Address to check
     * @return Available amount (custom or default, 0 if already claimed)
     */
    function getAvailableAirdropAmount(address _recipient) external view returns (uint256) {
        if (hasClaimed[_recipient]) {
            return 0; // Already claimed
        }
        
        if (customAirdropAmounts[_recipient] > 0) {
            return customAirdropAmounts[_recipient];
        }
        
        return airdropAmount;
    }
    
    /**
     * @dev Get airdrop info for a specific address
     * @param _recipient Address to check
     * @return claimed Whether the address has claimed
     * @return availableAmount Available amount to claim
     * @return isCustom Whether this is a custom amount
     */
    function getAirdropInfo(address _recipient) external view returns (
        bool claimed,
        uint256 availableAmount,
        bool isCustom
    ) {
        claimed = hasClaimed[_recipient];
        
        if (claimed) {
            availableAmount = 0;
            isCustom = false;
        } else {
            if (customAirdropAmounts[_recipient] > 0) {
                availableAmount = customAirdropAmounts[_recipient];
                isCustom = true;
            } else {
                availableAmount = airdropAmount;
                isCustom = false;
            }
        }
    }
    
    /**
     * @dev Owner can deposit tokens to the contract
     */
    function depositTokens(uint256 amount) external onlyOwner {
        require(shambaLuvToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }
    
    /**
     * @dev Owner can withdraw remaining tokens
     */
    function withdrawTokens(uint256 amount) external onlyOwner {
        uint256 contractBalance = shambaLuvToken.balanceOf(address(this));
        require(amount <= contractBalance, "Insufficient balance");
        
        require(shambaLuvToken.transfer(msg.sender, amount), "Transfer failed");
        emit TokensWithdrawn(msg.sender, amount);
    }
    
    /**
     * @dev Emergency withdraw all tokens
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 contractBalance = shambaLuvToken.balanceOf(address(this));
        if (contractBalance > 0) {
            require(shambaLuvToken.transfer(msg.sender, contractBalance), "Transfer failed");
            emit TokensWithdrawn(msg.sender, contractBalance);
        }
    }
    
    /**
     * @dev Withdraw ETH from contract
     */
    function withdrawETH(uint256 amount) external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(amount <= contractBalance, "Insufficient ETH balance");
        
        payable(msg.sender).sendValue(amount);
        emit ETHWithdrawn(msg.sender, amount);
    }
    
    /**
     * @dev Emergency withdraw all ETH
     */
    function emergencyWithdrawETH() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        if (contractBalance > 0) {
            payable(msg.sender).sendValue(contractBalance);
            emit ETHWithdrawn(msg.sender, contractBalance);
        }
    }
    
    /**
     * @dev Withdraw any ERC20 token from contract
     * @dev This function allows recovery of any ERC20 token sent to the contract
     */
    function withdrawERC20(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(token != address(shambaLuvToken), "Use withdrawTokens for SHAMBA LUV");
        
        IERC20 tokenContract = IERC20(token);
        uint256 contractBalance = tokenContract.balanceOf(address(this));
        require(amount <= contractBalance, "Insufficient token balance");
        
        require(tokenContract.transfer(msg.sender, amount), "Transfer failed");
        emit ERC20Withdrawn(token, msg.sender, amount);
    }
    
    /**
     * @dev Emergency withdraw all of any ERC20 token
     */
    function emergencyWithdrawERC20(address token) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(token != address(shambaLuvToken), "Use emergencyWithdraw for SHAMBA LUV");
        
        IERC20 tokenContract = IERC20(token);
        uint256 contractBalance = tokenContract.balanceOf(address(this));
        
        if (contractBalance > 0) {
            require(tokenContract.transfer(msg.sender, contractBalance), "Transfer failed");
            emit ERC20Withdrawn(token, msg.sender, contractBalance);
        }
    }
    
    /**
     * @dev Send all tokens back to a specific address as a precaution
     * @dev This function allows the owner to send all tokens (SHAMBA LUV, ETH, and other ERC20s) to a safe address
     */
    function sendAllTokensToAddress(address recipient) external onlyOwner {
        require(recipient != address(0), "Invalid recipient address");
        require(recipient != address(this), "Cannot send to self");
        
        // Send all SHAMBA LUV tokens
        uint256 shambaLuvBalance = shambaLuvToken.balanceOf(address(this));
        if (shambaLuvBalance > 0) {
            require(shambaLuvToken.transfer(recipient, shambaLuvBalance), "SHAMBA LUV transfer failed");
            emit TokensWithdrawn(recipient, shambaLuvBalance);
        }
        
        // Send all ETH
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            payable(recipient).sendValue(ethBalance);
            emit ETHWithdrawn(recipient, ethBalance);
        }
        
        // Note: For other ERC20 tokens, owner should use emergencyWithdrawERC20 for each token
    }
    
    /**
     * @dev Toggle emergency mode
     */
    function toggleEmergencyMode() external onlyOwner {
        emergencyMode = !emergencyMode;
        emit EmergencyModeToggled(emergencyMode);
    }
    
    /**
     * @dev Set maximum claims per block for rate limiting
     */
    function setMaxClaimsPerBlock(uint256 _maxClaims) external onlyOwner {
        require(_maxClaims > 0, "Max claims must be positive");
        uint256 oldMax = maxClaimsPerBlock;
        maxClaimsPerBlock = _maxClaims;
        emit MaxClaimsUpdated(oldMax, _maxClaims);
    }
    
    /**
     * @dev Set maximum total claims allowed
     */
    function setMaxTotalClaims(uint256 _maxTotal) external onlyOwner {
        require(_maxTotal >= totalRecipients, "Cannot set below current recipients");
        uint256 oldMax = maxTotalClaims;
        maxTotalClaims = _maxTotal;
        emit MaxTotalClaimsUpdated(oldMax, _maxTotal);
    }
    
    /**
     * @dev Reset rate limiting (useful for manual intervention)
     */
    function resetRateLimit() external onlyOwner {
        currentBlockClaims = 0;
        lastClaimBlock = 0;
        emit RateLimitReset(block.number);
    }
    
    /**
     * @dev Pause the contract
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause the contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Get contract balances for all assets
     */
    function getContractBalances() external view returns (
        uint256 shambaLuvBalance,
        uint256 ethBalance,
        bool hasOtherTokens
    ) {
        shambaLuvBalance = shambaLuvToken.balanceOf(address(this));
        ethBalance = address(this).balance;
        
        // Note: hasOtherTokens would require tracking or checking common tokens
        // For simplicity, we'll return false here
        hasOtherTokens = false;
        
        return (shambaLuvBalance, ethBalance, hasOtherTokens);
    }
}
