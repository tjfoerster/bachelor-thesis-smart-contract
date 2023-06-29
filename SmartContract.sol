// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

contract BusinessNetworkContract {

    struct Transaction {
        address sender;
        address receiver;
        int amount;
        string subject;
        uint timestamp;
    }

    struct Corp {
        address id;
        string name;
        int balance;
        Transaction[] transactions;
        uint transactionsSize;
        bool isParticipant;
    }

    mapping(address=>Corp) corps;

    uint totalParticipants = 0;

    modifier onlyParticipant() {
        require(isParticipant());
        _;
    }

    function isParticipant() public view returns (bool) {
        if(corps[msg.sender].isParticipant == true) {
            return true;
        } else {
            return false;
        }
    }

    function joinNetwork(int _balance, string memory _name) public {
        corps[msg.sender].id = msg.sender;
        corps[msg.sender].name = _name;
        corps[msg.sender].balance = _balance;
        corps[msg.sender].transactions.push(Transaction(msg.sender, msg.sender, _balance, "Initial transaction", block.timestamp));
        corps[msg.sender].transactionsSize = 1;
        corps[msg.sender].isParticipant = true;
        totalParticipants++;
    }

    function leaveNetwork() public onlyParticipant {
        delete corps[msg.sender];
        totalParticipants--;
    }

    function getMyCorpDetails() public view onlyParticipant returns (Corp memory) {
        return corps[msg.sender];
    }

    function setName(string memory _name) public onlyParticipant {
        corps[msg.sender].name = _name;
    }

    function addAmountToBalance(address _id, int _x) internal {
        corps[_id].balance += _x;
    }

    function addTransaction(address _receiver, int _amount, string memory _subject, uint _timestamp) public onlyParticipant {
        addAmountToBalance(msg.sender, -_amount);
        addAmountToBalance(_receiver, _amount);
        corps[msg.sender].transactions.push(Transaction(msg.sender, _receiver, _amount, _subject, _timestamp));
        corps[msg.sender].transactionsSize++;
        corps[_receiver].transactions.push(Transaction(msg.sender, _receiver, _amount, _subject, _timestamp));
        corps[_receiver].transactionsSize++;
    }
    
}
