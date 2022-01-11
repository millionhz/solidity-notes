// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract WelcomeToSolidity {
    
    constructor() {}

    function getResult() public pure returns (uint) {
        uint a = 5;
        uint b = 3;

        return a*b;
    }
}