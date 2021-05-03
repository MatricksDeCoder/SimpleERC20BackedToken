// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

/**
 * @title  SimpleERC20BackedToken
 * @dev    Collateral backed Token, based on some other ERC20 Token
 */
 
contract SimpleERC20BackedToken is ERC20 {

    IERC20 collateralToken;
    // price can come from some Oracle etc 
    uint price = 1;
    
    constructor(address _collateralToken) ERC20('SimpleERC20BackedToken', 'SEBT') {
     collateralToken = IERC20(_collateralToken);
    }
    
    // deposit token as collateral to get Token
    function deposit(uint _amountCollateralToken) external  {
        uint _amountBackedToken = _amountCollateralToken*price;
        collateralToken.transferFrom(msg.sender, address(this),_amountCollateralToken);
        _mint(msg.sender, _amountBackedToken);
    }
    
    // withdraw (unwrap backedToken) to get back the collateral Token
    function withdraw(uint _amount) external {
        require(_amount <= balanceOf(msg.sender), 'Insufficient balance');
        // at 1:1 ratio can be any ratio based on something... e.g some token engineering
        _burn(msg.sender, _amount);
        collateralToken.transfer(_amount/price);
    }
    
}
