 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLudo{
    uint constant public BOARD_SIZE = 52;
    address current_player;
    bool gameStarted;

    struct players{
        address playerAddress;
        Pawns[] pawns;
        bool hasWon;
    }

    struct Pawns{
        uint256 position;
        bool isHome;
    }

    struct GameBoard{
        uint startingPosition;
        uint finishingPosition;
        uint256[] safeSpaces;
    }

    // mapping(address => player) public players;

    players[] Players;
    

  

    function joinGame() public {
        require(!gameStarted, "gameStarted");

        Players.push(players({
            playerAddress : msg.sender,
            pawns: [0, 0, 0, BOARD_SIZE],
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

           
            if (player.position >= BOARD_SIZE) {
                player.position = BOARD_SIZE; 
            }

        }
    } 

    function rollDice() public{
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint8 dice_value = uint8((random%6)+1);
        movePlayer(dice_value);


    }

   
}