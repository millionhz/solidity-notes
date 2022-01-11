// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract ControlFlow {
    
    constructor() {}

    function validate(uint password) public pure returns (bool) {
        if(password == 124) {
            return true;
        }
        
        return false;
    }
}