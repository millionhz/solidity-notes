// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

struct Movie {
    string title;
    string director;
    uint id;
}

contract Structs {

    Movie movie;

    function makeMovie() public {
        movie = Movie("Spiderman", "Someone", 23);
    }

    function getMovieName() public view returns(string memory) {
        return movie.title; 
    }

}