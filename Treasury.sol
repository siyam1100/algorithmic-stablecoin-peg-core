// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface IBasisAsset is IERC20 {
    function mint(address to, uint256 amount) external;
    function burnFrom(address from, uint256 amount) external;
}

/**
 * @title Treasury
 * @dev Manages the expansion and contraction of the stablecoin supply based on price oracles.
 */
contract Treasury is Ownable, ReentrancyGuard {
    address public stablecoin;
    address public shareToken;
    
    uint256 public constant PERIOD = 8 hours;
    uint256 public lastEpochTime;
    uint256 public epoch = 0;

    event EpochAdvanced(uint256 indexed epoch, uint256 price);
    event SupplyExpanded(uint256 amount);

    constructor(address _stablecoin, address _shareToken) Ownable(msg.sender) {
        stablecoin = _stablecoin;
        shareToken = _shareToken;
        lastEpochTime = block.timestamp;
    }

    /**
     * @dev Core logic to adjust supply. In a production environment, 
     * this would fetch price from a Chainlink or Uniswap V3 Oracle.
     */
    function allocateSeigniorage(uint256 currentPrice) external onlyOwner {
        require(block.timestamp >= lastEpochTime + PERIOD, "Epoch not reached");
        
        if (currentPrice > 1e18) { // Price > $1.00 (using 18 decimals)
            uint256 percentage = (currentPrice - 1e18);
            uint256 supply = IERC20(stablecoin).totalSupply();
            uint256 amountToMint = (supply * percentage) / 1e18;
            
            IBasisAsset(stablecoin).mint(address(this), amountToMint);
            emit SupplyExpanded(amountToMint);
            // In a real DAO, tokens would be sent to a Boardroom/Staking contract here
        }

        lastEpochTime = block.timestamp;
        epoch++;
        emit EpochAdvanced(epoch, currentPrice);
    }
}
