// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IUniswapV2Router {
    function factory() external view returns (address);
    function WETH() external view returns (address);
}

contract ShambaLuv is ERC20, Ownable, ReentrancyGuard {
    uint256 public constant INITIAL_SUPPLY = 100_000_000_000_000_000 * 10**18;

    uint256 public reflectionFee = 30; // 3.0%
    uint256 public liquidityFee = 10;  // 1.0%
    uint256 public teamFee = 10;       // 1.0%
    uint256 public constant FEE_DENOMINATOR = 1000;

    uint256 public maxTransferPercent = 10; // 1% = 10 / 1000
    uint256 public swapThreshold = 1_000_000_000_000 * 10**18;

    address public teamWallet;
    address public liquidityWallet;
    address public uniswapRouter;
    address public pair;

    mapping(address => bool) public isExcludedFromFee;
    mapping(address => bool) public isExcludedFromReward;

    event SetPair(address indexed pair);
    event SetRouter(address indexed router);
    event MaxTransferPercentChanged(uint256 newMax);
    event FeesUpdated(uint256 reflection, uint256 liquidity, uint256 team);
    event SwapThresholdUpdated(uint256 newThreshold);

    modifier onlyRouter() {
        require(msg.sender == uniswapRouter, "Not router");
        _;
    }

    constructor(address _team, address _liq) ERC20("SHAMBA", "LUV") {
        teamWallet = _team;
        liquidityWallet = _liq != address(0) ? _liq : _msgSender();

        uniswapRouter = address(0); // set later
        _mint(msg.sender, INITIAL_SUPPLY);

        isExcludedFromFee[msg.sender] = true;
        isExcludedFromFee[address(this)] = true;

        isExcludedFromReward[msg.sender] = true;
        isExcludedFromReward[address(this)] = true;
        isExcludedFromReward[teamWallet] = true;
        isExcludedFromReward[liquidityWallet] = true;
        isExcludedFromReward[address(0x000000000000000000000000000000000000dEaD)] = true;
    }

    function setRouter(address _router) external onlyOwner {
        uniswapRouter = _router;
        emit SetRouter(_router);
    }

    function setPair(address _pair) external onlyOwner {
        pair = _pair;
        isExcludedFromReward[_pair] = true;
        emit SetPair(_pair);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(
            amount <= totalSupply() * maxTransferPercent / FEE_DENOMINATOR ||
            isExcludedFromFee[from] ||
            isExcludedFromFee[to],
            "Exceeds max transfer limit"
        );

        if (isExcludedFromFee[from] || isExcludedFromFee[to]) {
            super._transfer(from, to, amount);
            return;
        }

        uint256 totalFee = reflectionFee + liquidityFee + teamFee;
        uint256 feeAmount = (amount * totalFee) / FEE_DENOMINATOR;

        uint256 reflectionPart = (feeAmount * reflectionFee) / totalFee;
        uint256 liquidityPart = (feeAmount * liquidityFee) / totalFee;
        uint256 teamPart = feeAmount - reflectionPart - liquidityPart;

        uint256 sendAmount = amount - feeAmount;

        super._transfer(from, to, sendAmount);

        if (reflectionPart > 0) {
            _reflect(reflectionPart);
        }

        if (liquidityPart > 0) {
            super._transfer(from, address(this), liquidityPart);
        }

        if (teamPart > 0) {
            payable(teamWallet).transfer(teamPart);
        }

        if (balanceOf(address(this)) >= swapThreshold) {
            _swapAndLiquify();
        }
    }

    function _reflect(uint256 reflectionAmount) private {
        uint256 supply = totalSupply();

        for (uint i = 0; i < _excluded.length; i++) {
            supply -= balanceOf(_excluded[i]);
        }

        if (supply == 0) return;

        uint256 perTokenReward = reflectionAmount / supply;
        for (uint i = 0; i < _holders.length; i++) {
            address holder = _holders[i];
            if (!isExcludedFromReward[holder]) {
                _mint(holder, perTokenReward * balanceOf(holder));
            }
        }
    }

    function _swapAndLiquify() private nonReentrant {
        uint256 half = swapThreshold / 2;
        uint256 otherHalf = swapThreshold - half;

        // Swap half for ETH
        // Add liquidity using router (not implemented here)
        // Placeholder: emit swap event
        emit Transfer(address(this), liquidityWallet, swapThreshold);
    }

    function setMaxTransferPercent(uint256 newPercent) external onlyOwner {
        require(newPercent >= maxTransferPercent, "Can only increase");
        maxTransferPercent = newPercent;
        emit MaxTransferPercentChanged(newPercent);
    }

    function updateFees(uint256 _reflection, uint256 _liquidity, uint256 _team) external onlyOwner {
        require(_reflection + _liquidity + _team <= 100, "Too much fee");
        reflectionFee = _reflection;
        liquidityFee = _liquidity;
        teamFee = _team;
        emit FeesUpdated(_reflection, _liquidity, _team);
    }

    function updateSwapThreshold(uint256 newThreshold) external onlyOwner {
        swapThreshold = newThreshold;
        emit SwapThresholdUpdated(newThreshold);
    }

    function renounce() external onlyOwner {
        renounceOwnership();
    }

    receive() external payable {}
}

