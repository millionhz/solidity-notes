// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./Context.sol";
import "./ERC721.sol";

contract BoredDinosaur is ERC721{

    address owner;

    modifier OnlyOwner() {
        require(msg.sender == owner, "Can only be called by the owner");
        _;
    }

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        owner = _msgSender();
    }

    function mint(uint amount) public OnlyOwner {
        for(uint i = 1; i <= amount; i++) {
            _mint(owner, i);
        }
    }

    function transfer(address to, uint tokenId) public {
        _transfer(_msgSender(), to, tokenId);
    }

}