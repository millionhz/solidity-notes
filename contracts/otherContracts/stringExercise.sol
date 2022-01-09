// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract StringExercise{
    string private favoriteColor = "blue";

    constructor() {}

    function getColor() public view returns(string memory){
        return favoriteColor;
    }

    function changeColor(string memory newColor) public {
        favoriteColor = newColor;
    }

    function getColorSize() public view returns(uint){
        return bytes(favoriteColor).length;
    }
}