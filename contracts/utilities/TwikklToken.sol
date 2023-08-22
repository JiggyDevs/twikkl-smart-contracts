// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title TwikklToken
 * @dev A smart contract implementing the ERC20 token standard.
 */

contract TwikklToken is ERC20("Jiggy", "JGY"){

  /**
     * @dev Constructor to initialize the ERC20 token.
     */
  constructor() {
      _mint(address(this), 2000000e18);
  }

 /**
     * @notice Withdraw tokens from the contract to a specified address.
     * @param _to The address to which tokens will be transferred.
     * @param _amount The amount of tokens to be transferred.
     */
 function withdrawFromContract(address _to, uint _amount) public {
      uint currentBalance = balanceOf(address(this));
      uint withdrawAmount = _amount;
      require(currentBalance >= withdrawAmount, "Not enough money to transfer");
      _transfer(address(this), _to, withdrawAmount);
  }
    
}
