// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract Auction {

    address payable public beneficiary;
    address public prize;
    
    address public highest_bidder;
    uint public highest_bid;

    uint private end_time;

    mapping(address => uint) pendingClaims;

    event NewHighestBid(address highest_bidder, uint highest_bid);

    event Ended(address winner, uint amount);

    receive() external payable {
        revert("revert from recieve");
    }

    fallback() external payable {
        revert("revert from fallback");
    }

    modifier OnlyBeneficiary() {
        require(msg.sender == beneficiary, "Only benefitiary can call this function");
        _;
    }

    modifier OnlyHighestBidder() {
        require(msg.sender == highest_bidder, "Only the highest bidder can call this function");
        _;
    }

    modifier AfterAuctionEnd() {
        require(block.timestamp > end_time, "This function can only be called after auction ends");
        _;
    }

    modifier BeforeAuctionEnd() {
        require(block.timestamp <= end_time, "This function can only be called before the auction ends");
        _;
    }

    constructor(uint min, address _prize) {
        beneficiary = payable(msg.sender);
        end_time = block.timestamp + (min * 60 seconds);
        
        prize = _prize;
        // IPrize(prize).changeOwner(address(this));
    }

    function bid() public payable BeforeAuctionEnd {
        require(msg.value > highest_bid, "The bid is not higher than the current highest bid");

        pendingClaims[highest_bidder] += highest_bid;
        
        // set new highest bidder
        highest_bidder = msg.sender;
        highest_bid = msg.value;

        emit NewHighestBid(msg.sender, msg.value);
    }

    function claimHighestBid() public OnlyBeneficiary AfterAuctionEnd {
        beneficiary.transfer(highest_bid);

        emit Ended(highest_bidder, highest_bid);
    }

    function claimPrize() public OnlyHighestBidder AfterAuctionEnd {
        IPrize(prize).changeOwner(highest_bidder);
    }

    function refundBid() public {
        require(pendingClaims[msg.sender] > 0, "Your claimable amount is 0");

        uint ammountToRefund = pendingClaims[msg.sender];
        pendingClaims[msg.sender] = 0;

        payable(msg.sender).transfer(ammountToRefund);
    } 

    function isEnded() public view returns (bool) {
        return block.timestamp > end_time;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}

interface IPrize {
    function getOwner() external view returns (address);
    function changeOwner(address new_owner) external;
}

contract Prize {

    address owner;
    address approved_address;

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function changeOwner(address new_owner) public {
        //require(msg.sender == owner || msg.sender == approved_address, "Unauthorized Address");
        owner = new_owner;
    }

    function approve(address _approved_address) public {
        approved_address = _approved_address;
    }

}