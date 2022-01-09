// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Base{
    uint public data;

    constructor(uint _data) {
        data = _data;
    }
}

contract Derived is Base{
    constructor(uint _data) Base(_data) {}
}