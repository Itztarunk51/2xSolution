// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract OddEvenGame {
    uint public betAmount;
    uint public participationFee;
    uint public maxBetAmount;
    address payable public owner;
    mapping(address => uint) public bets;

    constructor(uint _betAmount, uint _participationFee, uint _maxBetAmount) public {
        betAmount = _betAmount;
        participationFee = _participationFee;
        maxBetAmount = _maxBetAmount;
        owner = msg.sender;
    }

    function placeBet(bool _isEven) public payable {
        require(msg.value == betAmount + participationFee, "Incorrect bet amount");
        require(bets[msg.sender] == 0, "Already placed a bet");
        bets[msg.sender] = _isEven ? 2 : 1;
    }

    function generateRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
    }

    function distributeWinnings() public {
    require(msg.sender == owner, "Only owner can distribute winnings");
    uint winningNumber = generateRandomNumber();
    bool isEven = winningNumber % 2 == 0;
    address[] memory players = new address[](address(this).balance / betAmount);
    uint count = 0;
    for (uint i = 0; i < players.length; i++) {
        if (bets[players[i]] != 0) {
            if ((isEven && bets[players[i]] == 2) || (!isEven && bets[players[i]] == 1)) {
                address(uint160(players[i])).transfer(betAmount * 2);
            }
            bets[players[i]] = 0;
            count++;
        }
    }
}


    function withdrawFees() public {
        require(msg.sender == owner, "Only owner can withdraw fees");
        owner.transfer(address(this).balance);
    }
}
