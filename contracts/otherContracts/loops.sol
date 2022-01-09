// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract loop {
    uint [] private number_list = [1, 2, 3, 4, 5, 6, 7, 8, 10];


    constructor() {}

    function checkNumMultiples(uint num) public view returns(uint) {
        uint num_of_multiples = 0;

        for(uint i = 0; i < number_list.length; i++) {
            if(num % number_list[i] == 0)
            {
                num_of_multiples++;
            }
        }

        return num_of_multiples;
    }
}
