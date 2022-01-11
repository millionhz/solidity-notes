// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Token {
    // only the creater can create the coin
    // anyone can send and recieve chishti coins

    address private admin;

    mapping(address => uint) public balances;

    event sendEvent(address from, address to, uint amount);

    constructor() {
        admin = msg.sender;
    }

    function mint(address reciever, uint amount) public {
        require(msg.sender == admin);

        balances[reciever] += amount;
    }

    function send(address reciever, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient amount");
        
        balances[msg.sender] -= amount;
        balances[reciever] += amount;

        emit sendEvent(msg.sender, reciever, amount);
    }


}

