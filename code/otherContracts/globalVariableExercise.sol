// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 < 0.9.0;

contract LedgerBalance {
    
    mapping(address => uint) public balance;

    function updateBalance(uint newBalance) public {
        balance[msg.sender] = newBalance;
    }
}

contract Updated {
    
    LedgerBalance ledgerBalance;
    
    function updateBalance() public {
        ledgerBalance = new LedgerBalance();
        ledgerBalance.updateBalance(30);
    }
}