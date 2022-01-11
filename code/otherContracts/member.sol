// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Member{
    string public name;
    uint public age;

    constructor(string memory _name, uint _age) {
        name = _name;
        age = _age;
    }
}