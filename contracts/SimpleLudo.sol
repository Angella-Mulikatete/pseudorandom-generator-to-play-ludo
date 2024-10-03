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
        bool hasStarted;
        uint position;
        
    }

    mapping(address => players) public _players;

    players[] Players;



    function joinGame() public {
        require(!gameStarted, "gameStarted");

        Players.push(players({
            playerAddress : msg.sender,
            pawns: [startLine, startLine, startLine, startLine],
            hasWon: false,
            hasStarted: false,
            position: 0

        }));
    }

    function movePlayer(uint8 diceValue) internal view{
         players memory player = _players[msg.sender];

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

    function rollDice() external view{
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, blockhash(block.number), msg.sender)));
        uint8 dice_value = uint8((random%6)+1);
        movePlayer(dice_value);


    }

   
}