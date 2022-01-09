// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

struct Movie {
    string title;
    string director;
}

contract MappingExercise {
    mapping(address => mapping(uint => Movie)) public movies;

    function addMovie(uint id, string memory title, string memory director) public {
        my_map[msg.sender][id] = Movie(title, director); 
    }

}