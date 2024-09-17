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
            pawns: [start1, start2, start3, start4],
            hasWon: false

        }));
    }

    function movePlayer() internal{
        if(current_player == msg.sender){
            current_player = address(uint256(current_player) ^0x1);
        }
    } 

    function rollDice() public{
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint8 dice_value = uint8((random%6)+1);
        movePlayer(dice_value);
    }
}