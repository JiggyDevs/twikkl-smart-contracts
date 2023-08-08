// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "solmate/tokens/ERC20.sol";

contract TwikklToken is ERC20("Jiggy", "JGY"){


  constructor() {
      _mint(address(this), 2000000e18);
  }

 function withdrawFromContract(address _to, uint _amount) public {
      uint currentBalance = balanceOf(address(this));
      uint withdrawAmount = _amount;
      require(currentBalance >= withdrawAmount, "Not enough money to transfer");
      _transfer(address(this), _to, withdrawAmount);
  }
    
}
