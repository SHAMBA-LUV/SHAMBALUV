// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 ^0.8.0 ^0.8.1 ^0.8.23;

/*
 * 🔗 SHAMBA LUV Cross-Chain Bridge
 * 
 * This contract enables cross-chain functionality for SHAMBA LUV token
 * without modifying the original SHAMBALUV contract. It acts as a bridge
 * between different blockchain networks while maintaining the integrity
 * of the main token contract.
 * 
 * Features:
 * • Cross-chain transfers via LayerZero
 * • Reflection synchronization across chains
 * • Fee distribution coordination
 * • Cross-chain governance
 * • Security and validation mechanisms
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

// SHAMBALUV Token Interface
interface ISHAMBALUV {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function getReflectionBalance(address account) external view returns (uint256);
    function getReflectionStats() external view returns (
        uint256 totalCollected,
        uint256 totalDistributed,
        uint256 currentIndex,
        uint256 totalHolders,
        uint256 averageReflection,
        uint256 lastDistribution
    );
}

// LayerZero Endpoint Interface
interface ILayerZeroEndpoint {
    function send(
        uint16 _dstChainId,
        bytes calldata _destination,
        bytes calldata _payload,
        address payable _refundAddress,
        address _zroPaymentAddress,
        bytes calldata _adapterParams
    ) external payable;
    
    function receivePayload(
        uint16 _srcChainId,
        bytes calldata _srcAddress,
        address _dstAddress,
        uint64 _nonce,
        uint256 _gasLimit,
        bytes calldata _payload
    ) external;
}

/**
 * @title SHAMBALUV Cross-Chain Bridge
 * @dev Enables cross-chain functionality for SHAMBA LUV token
 * @dev Maintains original contract integrity while adding cross-chain capabilities
 */
contract SHAMBALUVCrossChainBridge is Ownable, ReentrancyGuard {
    using Address for address payable;
    
    // ============ CONSTANTS ============
    uint256 public constant MINIMUM_TRANSFER = 1_000_000 * 1e18; // 1 million LUV minimum
    uint256 public constant MAXIMUM_TRANSFER = 1_000_000_000_000 * 1e18; // 1 trillion LUV maximum
    uint256 public constant BRIDGE_FEE = 100; // 1% bridge fee (100 basis points)
    uint256 public constant FEE_DENOMINATOR = 10000;
    
    // ============ STATE VARIABLES ============
    ISHAMBALUV public immutable luvToken;
    ILayerZeroEndpoint public lzEndpoint;
    
    // Cross-chain configuration
    mapping(uint256 => address) public chainIdToContract; // Chain ID to bridge contract
    mapping(uint256 => bool) public supportedChains;
    uint256 public homeChainId;
    
    // Transfer tracking
    mapping(bytes32 => bool) public processedTransfers;
    mapping(uint256 => uint256) public chainNonces;
    mapping(address => uint256) public userNonces;
    
    // Fee management
    uint256 public totalBridgeFees;
    address public feeCollector;
    
    // Security
    mapping(address => bool) public authorizedRelayers;
    bool public bridgePaused;
    
    // Cross-chain reflection synchronization
    mapping(uint256 => uint256) public chainReflectionIndexes;
    mapping(uint256 => uint256) public chainLastSyncTimestamps;
    uint256 public globalReflectionIndex;
    uint256 public lastGlobalSync;
    
    // ============ EVENTS ============
    event CrossChainTransferInitiated(
        address indexed sender,
        uint256 indexed destinationChainId,
        address indexed recipient,
        uint256 amount,
        uint256 bridgeFee,
        bytes32 transferId
    );
    
    event CrossChainTransferCompleted(
        address indexed recipient,
        uint256 indexed sourceChainId,
        uint256 amount,
        bytes32 transferId,
        uint256 timestamp
    );
    
    event BridgeFeeCollected(
        address indexed sender,
        uint256 amount,
        uint256 totalFees
    );
    
    event ReflectionSynced(
        uint256 indexed chainId,
        uint256 reflectionIndex,
        uint256 timestamp
    );
    
    event ChainAdded(
        uint256 indexed chainId,
        address indexed bridgeContract
    );
    
    event ChainRemoved(
        uint256 indexed chainId
    );
    
    event BridgePaused(
        bool paused,
        address indexed by
    );
    
    event FeeCollectorUpdated(
        address indexed oldCollector,
        address indexed newCollector
    );
    
    event RelayerAuthorized(
        address indexed relayer,
        bool authorized
    );
    
    // ============ MODIFIERS ============
    modifier onlyAuthorized() {
        require(authorizedRelayers[msg.sender] || msg.sender == owner(), "Not authorized");
        _;
    }
    
    modifier whenNotPaused() {
        require(!bridgePaused, "Bridge is paused");
        _;
    }
    
    modifier onlySupportedChain(uint256 _chainId) {
        require(supportedChains[_chainId], "Unsupported chain");
        _;
    }
    
    // ============ CONSTRUCTOR ============
    constructor(
        address _luvToken,
        address _lzEndpoint,
        uint256 _homeChainId
    ) Ownable(msg.sender) {
        require(_luvToken != address(0), "Invalid token address");
        require(_lzEndpoint != address(0), "Invalid endpoint address");
        
        luvToken = ISHAMBALUV(_luvToken);
        lzEndpoint = ILayerZeroEndpoint(_lzEndpoint);
        homeChainId = _homeChainId;
        feeCollector = msg.sender;
        
        // Add home chain to supported chains
        supportedChains[_homeChainId] = true;
        chainIdToContract[_homeChainId] = address(this);
        
        emit ChainAdded(_homeChainId, address(this));
    }
    
    // ============ CROSS-CHAIN TRANSFER FUNCTIONS ============
    
    /**
     * @dev Initiate cross-chain transfer
     * @param _destinationChainId Target chain ID
     * @param _recipient Recipient address on target chain
     * @param _amount Amount to transfer
     */
    function transferCrossChain(
        uint256 _destinationChainId,
        address _recipient,
        uint256 _amount
    ) external payable whenNotPaused onlySupportedChain(_destinationChainId) nonReentrant {
        require(_amount >= MINIMUM_TRANSFER, "Amount too small");
        require(_amount <= MAXIMUM_TRANSFER, "Amount too large");
        require(_recipient != address(0), "Invalid recipient");
        require(_destinationChainId != homeChainId, "Cannot transfer to same chain");
        
        // Calculate bridge fee
        uint256 bridgeFee = (_amount * BRIDGE_FEE) / FEE_DENOMINATOR;
        uint256 transferAmount = _amount - bridgeFee;
        
        // Check user balance
        require(luvToken.balanceOf(msg.sender) >= _amount, "Insufficient balance");
        
        // Transfer tokens to bridge (includes bridge fee)
        require(luvToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        // Collect bridge fee
        totalBridgeFees += bridgeFee;
        emit BridgeFeeCollected(msg.sender, bridgeFee, totalBridgeFees);
        
        // Generate transfer ID
        bytes32 transferId = keccak256(abi.encodePacked(
            msg.sender,
            _destinationChainId,
            _recipient,
            transferAmount,
            userNonces[msg.sender]++,
            block.timestamp
        ));
        
        // Prepare cross-chain message
        bytes memory payload = abi.encode(
            transferId,
            msg.sender,
            _recipient,
            transferAmount,
            block.timestamp
        );
        
        // Send cross-chain message
        lzEndpoint.send{value: msg.value}(
            uint16(_destinationChainId),
            abi.encodePacked(chainIdToContract[_destinationChainId]),
            payload,
            payable(msg.sender),
            address(0),
            bytes("")
        );
        
        emit CrossChainTransferInitiated(
            msg.sender,
            _destinationChainId,
            _recipient,
            transferAmount,
            bridgeFee,
            transferId
        );
    }
    
    /**
     * @dev Complete cross-chain transfer (called by LayerZero)
     * @param _srcChainId Source chain ID
     * @param _payload Transfer data
     */
    function _nonblockingLzReceive(
        uint16 _srcChainId,
        bytes calldata _srcAddress,
        uint64 _nonce,
        bytes calldata _payload
    ) internal override {
        require(_validateCrossChainMessage(_payload, _srcAddress), "Invalid message");
        
        (bytes32 transferId, address sender, address recipient, uint256 amount, uint256 timestamp) = abi.decode(
            _payload,
            (bytes32, address, address, uint256, uint256)
        );
        
        require(!processedTransfers[transferId], "Transfer already processed");
        require(recipient != address(0), "Invalid recipient");
        
        // Mark transfer as processed
        processedTransfers[transferId] = true;
        
        // Transfer tokens to recipient
        require(luvToken.transfer(recipient, amount), "Transfer to recipient failed");
        
        emit CrossChainTransferCompleted(
            recipient,
            uint256(_srcChainId),
            amount,
            transferId,
            timestamp
        );
    }
    
    // ============ REFLECTION SYNCHRONIZATION ============
    
    /**
     * @dev Synchronize reflection data across chains
     * @param _sourceChainId Source chain ID
     * @param _reflectionIndex New reflection index
     * @param _totalSupply Total supply on source chain
     */
    function syncReflectionData(
        uint256 _sourceChainId,
        uint256 _reflectionIndex,
        uint256 _totalSupply
    ) external onlyAuthorized {
        require(supportedChains[_sourceChainId], "Unsupported chain");
        require(_sourceChainId != homeChainId, "Cannot sync with self");
        
        // Update chain-specific reflection data
        chainReflectionIndexes[_sourceChainId] = _reflectionIndex;
        chainLastSyncTimestamps[_sourceChainId] = block.timestamp;
        
        // Calculate global reflection index (weighted average)
        _updateGlobalReflectionIndex();
        
        emit ReflectionSynced(_sourceChainId, _reflectionIndex, block.timestamp);
    }
    
    /**
     * @dev Update global reflection index based on all chains
     */
    function _updateGlobalReflectionIndex() internal {
        uint256 totalWeightedIndex = 0;
        uint256 totalWeight = 0;
        
        // Calculate weighted average across all chains
        for (uint256 i = 0; i < getSupportedChainCount(); i++) {
            uint256 chainId = getSupportedChainByIndex(i);
            if (chainId != homeChainId && chainLastSyncTimestamps[chainId] > 0) {
                uint256 chainSupply = getChainTotalSupply(chainId);
                totalWeightedIndex += chainReflectionIndexes[chainId] * chainSupply;
                totalWeight += chainSupply;
            }
        }
        
        // Add home chain data
        uint256 homeSupply = luvToken.totalSupply();
        totalWeightedIndex += globalReflectionIndex * homeSupply;
        totalWeight += homeSupply;
        
        if (totalWeight > 0) {
            globalReflectionIndex = totalWeightedIndex / totalWeight;
            lastGlobalSync = block.timestamp;
        }
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    /**
     * @dev Add supported chain
     * @param _chainId Chain ID to add
     * @param _bridgeContract Bridge contract address on that chain
     */
    function addSupportedChain(
        uint256 _chainId,
        address _bridgeContract
    ) external onlyOwner {
        require(_chainId != homeChainId, "Cannot add home chain");
        require(_bridgeContract != address(0), "Invalid bridge contract");
        require(!supportedChains[_chainId], "Chain already supported");
        
        supportedChains[_chainId] = true;
        chainIdToContract[_chainId] = _bridgeContract;
        
        emit ChainAdded(_chainId, _bridgeContract);
    }
    
    /**
     * @dev Remove supported chain
     * @param _chainId Chain ID to remove
     */
    function removeSupportedChain(uint256 _chainId) external onlyOwner {
        require(_chainId != homeChainId, "Cannot remove home chain");
        require(supportedChains[_chainId], "Chain not supported");
        
        supportedChains[_chainId] = false;
        delete chainIdToContract[_chainId];
        
        emit ChainRemoved(_chainId);
    }
    
    /**
     * @dev Pause/unpause bridge
     * @param _paused Pause state
     */
    function setBridgePaused(bool _paused) external onlyOwner {
        bridgePaused = _paused;
        emit BridgePaused(_paused, msg.sender);
    }
    
    /**
     * @dev Update fee collector
     * @param _newCollector New fee collector address
     */
    function setFeeCollector(address _newCollector) external onlyOwner {
        require(_newCollector != address(0), "Invalid collector");
        
        address oldCollector = feeCollector;
        feeCollector = _newCollector;
        
        emit FeeCollectorUpdated(oldCollector, _newCollector);
    }
    
    /**
     * @dev Authorize/unauthorize relayer
     * @param _relayer Relayer address
     * @param _authorized Authorization status
     */
    function setRelayerAuthorization(
        address _relayer,
        bool _authorized
    ) external onlyOwner {
        authorizedRelayers[_relayer] = _authorized;
        emit RelayerAuthorized(_relayer, _authorized);
    }
    
    /**
     * @dev Withdraw collected bridge fees
     */
    function withdrawBridgeFees() external {
        require(msg.sender == feeCollector, "Not fee collector");
        require(totalBridgeFees > 0, "No fees to withdraw");
        
        uint256 amount = totalBridgeFees;
        totalBridgeFees = 0;
        
        require(luvToken.transfer(feeCollector, amount), "Fee withdrawal failed");
    }
    
    /**
     * @dev Emergency withdraw tokens (owner only)
     * @param _token Token address to withdraw
     * @param _amount Amount to withdraw
     */
    function emergencyWithdraw(
        address _token,
        uint256 _amount
    ) external onlyOwner {
        require(_amount > 0, "Amount must be greater than 0");
        
        if (_token == address(luvToken)) {
            require(_amount <= luvToken.balanceOf(address(this)) - totalBridgeFees, "Insufficient balance");
        }
        
        // Transfer tokens
        if (_token == address(0)) {
            payable(owner()).sendValue(_amount);
        } else {
            require(IERC20(_token).transfer(owner(), _amount), "Transfer failed");
        }
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get cross-chain transfer status
     * @param _transferId Transfer ID to check
     * @return processed Whether transfer has been processed
     */
    function getTransferStatus(bytes32 _transferId) external view returns (bool processed) {
        return processedTransfers[_transferId];
    }
    
    /**
     * @dev Get chain reflection data
     * @param _chainId Chain ID to query
     * @return reflectionIndex Current reflection index
     * @return lastSync Last sync timestamp
     */
    function getChainReflectionData(
        uint256 _chainId
    ) external view returns (uint256 reflectionIndex, uint256 lastSync) {
        return (chainReflectionIndexes[_chainId], chainLastSyncTimestamps[_chainId]);
    }
    
    /**
     * @dev Get global reflection index
     * @return index Global reflection index
     * @return lastSync Last global sync timestamp
     */
    function getGlobalReflectionIndex() external view returns (uint256 index, uint256 lastSync) {
        return (globalReflectionIndex, lastGlobalSync);
    }
    
    /**
     * @dev Get supported chain count
     * @return count Number of supported chains
     */
    function getSupportedChainCount() public view returns (uint256 count) {
        // This is a simplified implementation
        // In production, you'd maintain a separate array of supported chains
        return 5; // Example: Polygon, Ethereum, BSC, Arbitrum, Optimism
    }
    
    /**
     * @dev Get supported chain by index
     * @param _index Index of supported chain
     * @return chainId Chain ID
     */
    function getSupportedChainByIndex(uint256 _index) public view returns (uint256 chainId) {
        // This is a simplified implementation
        // In production, you'd maintain a separate array of supported chains
        uint256[5] memory chains = [137, 1, 56, 42161, 10]; // Polygon, Ethereum, BSC, Arbitrum, Optimism
        require(_index < chains.length, "Index out of bounds");
        return chains[_index];
    }
    
    /**
     * @dev Get chain total supply (placeholder)
     * @param _chainId Chain ID
     * @return supply Total supply on that chain
     */
    function getChainTotalSupply(uint256 _chainId) public view returns (uint256 supply) {
        // This would be implemented with oracle or cross-chain data
        // For now, return a placeholder value
        return 100_000_000_000_000_000 * 1e18; // 100 quadrillion
    }
    
    /**
     * @dev Get bridge statistics
     * @return totalFees Total bridge fees collected
     * @return supportedChainsCount Number of supported chains
     * @return bridgePausedStatus Whether bridge is paused
     */
    function getBridgeStats() external view returns (
        uint256 totalFees,
        uint256 supportedChainsCount,
        bool bridgePausedStatus
    ) {
        return (totalBridgeFees, getSupportedChainCount(), bridgePaused);
    }
    
    // ============ INTERNAL FUNCTIONS ============
    
    /**
     * @dev Validate cross-chain message
     * @param _payload Message payload
     * @param _srcAddress Source address
     * @return valid Whether message is valid
     */
    function _validateCrossChainMessage(
        bytes calldata _payload,
        bytes calldata _srcAddress
    ) internal view returns (bool valid) {
        // Verify message source is a supported bridge contract
        address sourceBridge = abi.decode(_srcAddress, (address));
        require(supportedChains[getChainIdFromAddress(sourceBridge)], "Invalid source");
        
        // Verify payload format
        require(_payload.length >= 32, "Invalid payload length");
        
        return true;
    }
    
    /**
     * @dev Get chain ID from bridge address (placeholder)
     * @param _bridgeAddress Bridge contract address
     * @return chainId Chain ID
     */
    function getChainIdFromAddress(address _bridgeAddress) internal pure returns (uint256 chainId) {
        // This would be implemented with a mapping or oracle
        // For now, return a placeholder
        return 137; // Default to Polygon
    }
    
    // ============ RECEIVE FUNCTION ============
    receive() external payable {}
}

// IERC20 interface for emergency withdrawals
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
} 
