// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract C {
    uint private data;
    uint public info;

    constructor() {
        info = 10;
    }

    function increment(uint a) internal pure returns(uint) {
        return a + 1;
    }

    function updateData(uint a) public {
        data = a;
    }

    function getData() public view returns(uint) {
        return data;
    }

    function compute(uint a, uint b) internal pure returns(uint) {
        return a + b;
    }
}

contract D {

    C private c = new C();

    function readInfo() public view returns(uint) {
        return c.info();
    }
}

contract E is C {
    uint internal result;

    function getComputedResult() public pure returns(uint) {
        return compute(24, 5);
    }

    function getResult() public view returns(uint) {
        return result;
    }

    function readInfo() public view returns(uint) {
        return info;
    }
}