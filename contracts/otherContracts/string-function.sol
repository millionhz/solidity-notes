// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract String{
    string greeting = "Hello";

    constructor() {}

    function getGreeting() public view returns(string memory) {
        return greeting;
    }

    function changeGreeting(string memory newString) public {
        greeting = newString;
    }
}