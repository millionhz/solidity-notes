// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Mapping {

    mapping(address => uint) public my_map;

    function setAddress(address _address, uint index) public {
        my_map[_address] = index;
    }

    function getIndex(address _address) public view returns(uint) {
        return my_map[_address];
    }

    function removeAddress(address _address) public {
        delete my_map[_address];
    }

}