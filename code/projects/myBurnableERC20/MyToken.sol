// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./ERC20Burnable.sol";

contract Token is ERC20Burnable {

    address private owner;

    constructor(string memory name_, string memory symbol_, uint _totalSupply) ERC20(name_, symbol_) {

        owner = _msgSender();
        _mint(owner, _totalSupply);
    }

}