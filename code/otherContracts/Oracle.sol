// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Oracle {
    address private admin;
    uint public rand;

    constructor() {
        admin = msg.sender;
    }

    function setRand(uint _rand) external {
        require(msg.sender == admin, "Call Not Allowed");
        rand = _rand;
    }
}

contract RandomNumber {

    Oracle oracle;

    constructor(address oracleAddress) {
        oracle = Oracle(oracleAddress);
    }

    function randMod(uint range) external view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, oracle.rand, msg.sender))) % range;
    }
}