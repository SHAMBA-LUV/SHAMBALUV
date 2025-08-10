// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 ^0.8.20 ^0.8.23;

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// deploy/ShambaLuvAirdrop.sol

/**
 * @title ShambaLuvAirdrop
 * @dev Flexible airdrop contract that can handle any ERC20 tokens
 * @notice Automatically gives tokens to new users who connect their wallet
 * @notice Supports multiple token types and emergency rescue functions
 */
contract ShambaLuvAirdrop is Ownable, ReentrancyGuard {
    // Default token for SHAMBA LUV airdrops
    IERC20 public immutable defaultToken;
    
    // Airdrop configuration per token
    struct AirdropConfig {
        uint256 amount;
        bool isActive;
        uint256 totalClaimed;
        uint256 totalRecipients;
    }
    
    // Token configurations
    mapping(address => AirdropConfig) public tokenConfigs;
    
    // Track who has already claimed per token
    mapping(address => mapping(address => bool)) public hasClaimed;
    
    // Events
    event AirdropClaimed(address indexed token, address indexed recipient, uint256 amount);
    event AirdropConfigUpdated(address indexed token, uint256 oldAmount, uint256 newAmount, bool isActive);
    event TokensDeposited(address indexed token, address indexed from, uint256 amount);
    event TokensWithdrawn(address indexed token, address indexed to, uint256 amount);
    event TokensRescued(address indexed token, address indexed to, uint256 amount);
    event EmergencyWithdraw(address indexed token, address indexed to, uint256 amount);
    
    constructor(address _defaultToken) Ownable(msg.sender) {
        require(_defaultToken != address(0), "Invalid default token address");
        defaultToken = IERC20(_defaultToken);
        
        // Set default configuration for the main token
        tokenConfigs[_defaultToken] = AirdropConfig({
            amount: 1_000_000_000_000 * 1e18, // 1 trillion tokens
            isActive: true,
            totalClaimed: 0,
            totalRecipients: 0
        });
    }
    
    /**
     * @dev Claim airdrop tokens for the default token (one-time per address)
     */
    function claimAirdrop() external nonReentrant {
        claimAirdropForToken(address(defaultToken));
    }
    
    /**
     * @dev Claim airdrop tokens for a specific token (one-time per address per token)
     */
    function claimAirdropForToken(address token) public nonReentrant {
        require(token != address(0), "Invalid token address");
        require(!hasClaimed[token][msg.sender], "Already claimed for this token");
        
        AirdropConfig storage config = tokenConfigs[token];
        require(config.isActive, "Airdrop not active for this token");
        require(config.amount > 0, "Airdrop amount not set");
        
        // Check contract has enough tokens
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        require(contractBalance >= config.amount, "Insufficient tokens in contract");
        
        // Mark as claimed
        hasClaimed[token][msg.sender] = true;
        config.totalClaimed += config.amount;
        config.totalRecipients++;
        
        // Transfer tokens
        require(IERC20(token).transfer(msg.sender, config.amount), "Transfer failed");
        
        emit AirdropClaimed(token, msg.sender, config.amount);
    }
    
    /**
     * @dev Check if an address has already claimed for a specific token
     */
    function hasUserClaimed(address token, address user) external view returns (bool) {
        return hasClaimed[token][user];
    }
    
    /**
     * @dev Check if an address has already claimed for the default token
     */
    function hasUserClaimed(address user) external view returns (bool) {
        return hasClaimed[address(defaultToken)][user];
    }
    
    /**
     * @dev Get airdrop stats for a specific token
     */
    function getAirdropStats(address token) external view returns (
        uint256 airdropAmount,
        uint256 totalClaimed,
        uint256 totalRecipients,
        uint256 contractBalance,
        bool isActive
    ) {
        AirdropConfig storage config = tokenConfigs[token];
        return (
            config.amount,
            config.totalClaimed,
            config.totalRecipients,
            IERC20(token).balanceOf(address(this)),
            config.isActive
        );
    }
    
    /**
     * @dev Get airdrop stats for the default token
     */
    function getAirdropStats() external view returns (
        uint256 airdropAmount,
        uint256 totalClaimed,
        uint256 totalRecipients,
        uint256 contractBalance,
        bool isActive
    ) {
        AirdropConfig storage config = tokenConfigs[address(defaultToken)];
        return (
            config.amount,
            config.totalClaimed,
            config.totalRecipients,
            IERC20(defaultToken).balanceOf(address(this)),
            config.isActive
        );
    }
    
    /**
     * @dev Owner can set airdrop configuration for any token
     */
    function setAirdropConfig(address token, uint256 amount, bool isActive) external onlyOwner {
        require(token != address(0), "Invalid token address");
        
        AirdropConfig storage config = tokenConfigs[token];
        uint256 oldAmount = config.amount;
        
        config.amount = amount;
        config.isActive = isActive;
        
        emit AirdropConfigUpdated(token, oldAmount, amount, isActive);
    }
    
    /**
     * @dev Owner can update airdrop amount for the default token
     */
    function setAirdropAmount(uint256 _newAmount) external onlyOwner {
        require(address(defaultToken) != address(0), "Invalid token address");
        
        AirdropConfig storage config = tokenConfigs[address(defaultToken)];
        uint256 oldAmount = config.amount;
        
        config.amount = _newAmount;
        config.isActive = true;
        
        emit AirdropConfigUpdated(address(defaultToken), oldAmount, _newAmount, true);
    }
    
    /**
     * @dev Owner can deposit tokens to the contract
     */
    function depositTokens(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");
        
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit TokensDeposited(token, msg.sender, amount);
    }
    
    /**
     * @dev Owner can deposit default tokens to the contract
     */
    function depositTokens(uint256 amount) external onlyOwner {
        require(address(defaultToken) != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");
        
        require(IERC20(defaultToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit TokensDeposited(address(defaultToken), msg.sender, amount);
    }
    
    /**
     * @dev Owner can withdraw tokens from the contract
     */
    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");
        
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        require(amount <= contractBalance, "Insufficient balance");
        
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");
        emit TokensWithdrawn(token, msg.sender, amount);
    }
    
    /**
     * @dev Owner can withdraw default tokens from the contract
     */
    function withdrawTokens(uint256 amount) external onlyOwner {
        require(address(defaultToken) != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");
        
        uint256 contractBalance = IERC20(defaultToken).balanceOf(address(this));
        require(amount <= contractBalance, "Insufficient balance");
        
        require(IERC20(defaultToken).transfer(msg.sender, amount), "Transfer failed");
        emit TokensWithdrawn(address(defaultToken), msg.sender, amount);
    }
    
    /**
     * @dev Emergency withdraw all tokens of a specific type
     */
    function emergencyWithdraw(address token) external onlyOwner {
        require(token != address(0), "Invalid token address");
        
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        if (contractBalance > 0) {
            require(IERC20(token).transfer(msg.sender, contractBalance), "Transfer failed");
            emit EmergencyWithdraw(token, msg.sender, contractBalance);
        }
    }
    
    /**
     * @dev Emergency withdraw all default tokens
     */
    function emergencyWithdraw() external onlyOwner {
        require(address(defaultToken) != address(0), "Invalid token address");
        
        uint256 contractBalance = IERC20(defaultToken).balanceOf(address(this));
        if (contractBalance > 0) {
            require(IERC20(defaultToken).transfer(msg.sender, contractBalance), "Transfer failed");
            emit EmergencyWithdraw(address(defaultToken), msg.sender, contractBalance);
        }
    }
    
    /**
     * @dev Rescue tokens that were accidentally sent to the contract
     * @notice This function allows the owner to rescue any ERC20 tokens
     * @notice that were sent to the contract but not intended for airdrops
     */
    function rescueTokens(address token, address to, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than 0");
        
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        require(amount <= contractBalance, "Insufficient balance");
        
        require(IERC20(token).transfer(to, amount), "Transfer failed");
        emit TokensRescued(token, to, amount);
    }
    
    /**
     * @dev Rescue all tokens of a specific type
     */
    function rescueAllTokens(address token, address to) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(to != address(0), "Invalid recipient address");
        
        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        if (contractBalance > 0) {
            require(IERC20(token).transfer(to, contractBalance), "Transfer failed");
            emit TokensRescued(token, to, contractBalance);
        }
    }
    
    /**
     * @dev Get contract balance for any token
     */
    function getTokenBalance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }
    
    /**
     * @dev Get default token balance
     */
    function getTokenBalance() external view returns (uint256) {
        return IERC20(defaultToken).balanceOf(address(this));
    }
    
    /**
     * @dev Check if airdrop is active for a specific token
     */
    function isAirdropActive(address token) external view returns (bool) {
        return tokenConfigs[token].isActive;
    }
    
    /**
     * @dev Check if default airdrop is active
     */
    function isAirdropActive() external view returns (bool) {
        return tokenConfigs[address(defaultToken)].isActive;
    }
}

