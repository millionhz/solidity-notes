// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Reciever.sol";

contract Auction is IERC721Receiver {

    address private beneficiary;
    address private collection;
    uint private tokenId; 

    address private highestBidder;
    uint private highestBid;

    uint private endTime;
    bool private started;

    mapping(address => uint) pendingClaims;

    event NewHighestBid(address highest_bidder, uint highest_bid);

    event Started();

    receive() external payable {
        revert("Transaction reverted from recieve");
    }

    fallback() external payable {
        revert("Transaction reverted from fallback");
    }

    modifier OnlyBeneficiary() {
        require(msg.sender == beneficiary, "Only benefitiary can call this function");
        _;
    }

    modifier OnlyHighestBidder() {
        require(msg.sender == highestBidder, "Only the highest bidder can call this function");
        _;
    }

    modifier AfterAuctionEnd() {
        require(block.timestamp > endTime, "This function can only be called after auction ends");
        _;
    }

    modifier BeforeAuctionEnd() {
        require(block.timestamp <= endTime, "This function can only be called before the auction ends");
        _;
    }

    modifier AfterAuctionStart() {
        require(started, "This function can only be called after the auction starts");
        _;
    }

    constructor(address collection_, uint tokenId_) {
        beneficiary = msg.sender;

        collection = collection_;
        tokenId = tokenId_;

        started = false;
    }

    function start(uint durationInMinutes_) public OnlyBeneficiary {
        require(!started, "Auction has already been started");
        require(address(this) == IERC721(collection).ownerOf(tokenId), "Auction can only be started after token transfer");

        endTime = block.timestamp + (durationInMinutes_ * 60 seconds);
        
        started = true;
        
        emit Started();
    }

    function bid() public payable AfterAuctionStart BeforeAuctionEnd {
        require(msg.value > highestBid, "The bid is not higher than the current highest bid");

        pendingClaims[highestBidder] += highestBid;
        
        highestBidder = msg.sender;
        highestBid = msg.value;

        emit NewHighestBid(msg.sender, msg.value);
    }

    function claimAmount() public OnlyBeneficiary AfterAuctionStart AfterAuctionEnd {
        payable(beneficiary).transfer(highestBid);
    }

    function claimPrize() public OnlyHighestBidder AfterAuctionStart AfterAuctionEnd {
        IERC721(collection).safeTransferFrom(address(this), highestBidder, tokenId, "");
    }

    function refundBid() public {
        require(pendingClaims[msg.sender] > 0, "Your claimable amount is 0");

        uint ammountToRefund = pendingClaims[msg.sender];
        pendingClaims[msg.sender] = 0;

        payable(msg.sender).transfer(ammountToRefund);
    } 

    function refundAccidentalTokenTransfer(address collection_, uint tokenId_) public OnlyBeneficiary{
        require(tokenId_ != tokenId, "Can not refund nft pending auction");

        IERC721(collection_).safeTransferFrom(address(this), beneficiary, tokenId_, "");
    }

    function refundFailedAuctionToken() public OnlyBeneficiary AfterAuctionEnd{
        require(highestBidder == address(0), "Highest bidder present; can not redund");
        IERC721(collection).safeTransferFrom(address(this), beneficiary, tokenId, "");
    } 

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId_,
        bytes calldata data
    ) public returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function isEnded() public view returns (bool) {
        return block.timestamp > endTime;
    }

    function getHighestBid() public view returns (uint) {
        return highestBid;
    }

    function getCollection() public view returns (address) {
        return collection;
    }

    function getTokenId() public view returns (uint) {
        return tokenId;
    }

    function getTokenURI() public view returns (string memory) {
        return IERC721Metadata(collection).tokenURI(tokenId);
    }
}