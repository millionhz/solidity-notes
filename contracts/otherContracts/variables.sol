// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Variables {
    uint number = 44;

    function setNumber(uint val) public {
        number = val;
    } 

}
