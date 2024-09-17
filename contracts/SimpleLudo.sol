 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLudo{
    uint constant public finishLine = 52;
     uint constant public startLine = 0;
    address current_player;
    bool gameStarted;
    bool gameFinished;


    struct players{
        address playerAddress;
        uint[4] pawns;
        bool hasWon;
    }

    // mapping(address => player) public players;

    players[] Players;

    

  

    function joinGame() public {
        require(!gameStarted, "gameStarted");

        Players.push(players({
            playerAddress : msg.sender,
            pawns: [startLine, startLine, startLine, startLine],
            hasWon: false

        }));
    }

    function movePlayer(uint8 diceValue) internal{
         players storage player = players[msg.sender];

        if (!player.hasStarted && diceValue == 6) {
            player.hasStarted = true;
        }

       
        if (player.hasStarted) {
            player.position += diceValue;

           
            if (player.position >= finishLine) {
                player.position = finishLine; 
            }

        }
    } 

    function rollDice() public{
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint8 dice_value = uint8((random%6)+1);
        movePlayer(dice_value);


    }

   
}