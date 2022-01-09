// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

library Search {
    function getIndex(uint[] memory arr, uint data) public pure returns (uint) {
        for(uint i = 0; i < arr.length; i++)
        {
            if(data == arr[i])
            {
                return i;
            }
        }
        return 0;
    }
}

contract Test {

    using Search for uint[]; // use methods in Search for all uint[]

    uint[] arr = [1, 2, 3, 4, 5];

    function getIndex(uint data) public view returns (uint) {
        return arr.getIndex(data);
    }
}