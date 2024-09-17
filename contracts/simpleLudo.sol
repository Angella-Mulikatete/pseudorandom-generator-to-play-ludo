 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLudo {

    uint constant public BOARD_SIZE = 52;

   
    struct Player {
        uint position;  
        bool hasStarted;
    }

    
    mapping(address => Player) public players;

    // Store whose turn it is
    address public currentPlayer;

    // Event for rolling the dice
    event DiceRolled(address indexed player, uint value);

    // Event when a player moves
    event PlayerMoved(address indexed player, uint newPosition);

    // Modifier to ensure it's the player's turn
    modifier isPlayerTurn() {
        require(msg.sender == currentPlayer, "It's not your turn.");
        _;
    }

    // Join the game (reset position)
    function joinGame() public {
        players[msg.sender] = Player(0, false); // Player starts off board (position 0, hasn't started)
        if (currentPlayer == address(0)) {
            currentPlayer = msg.sender; // Set first player as current
        }
    }

// struct GameBoard {
//     uint256[] safeSpaces;
//     uint256 startingPosition;
//     uint256 finishLine;
// }

// struct Pawn {
//     uint256 position;
//     bool isHome;
// }

// struct Player {
//     address playerAddress;
//     Pawn[] pawns;
//     bool hasWon;
// }
    
// function joinGame() public {
//     // Check if the game has started
//     require(!gameStarted, "Game has already started");

//     // Add a new player to the players array
//     players.push(Player({
//         playerAddress: msg.sender,
//         pawns: [startingPosition, startingPosition, startingPosition, startingPosition],
//         hasWon: false
//     }));
// }

    // Roll the dice (random number between 1-6)
    function rollDice() public isPlayerTurn returns (uint8) {
        require(players[msg.sender].position < BOARD_SIZE, "Game over, you have already won!");

        // Generate a pseudorandom number using block attributes
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint8 diceValue = uint8((random % 6) + 1);  // Dice value between 1 and 6

        emit DiceRolled(msg.sender, diceValue); // Emit event for the roll

        movePlayer(diceValue);

        // Switch to the next player
        nextPlayer();

        return diceValue;
    }

//     uint256 private constant BLOCK_HASH_OFFSET = 100; // Adjust as needed

// function rollDice() internal returns (uint256) {
//     uint256 seed = uint256(keccak256(abi.encodePacked(block.blockhash(block.number - 1))));
//     return (seed % BLOCK_HASH_OFFSET) + 1;
// }

// function rollDice() public {
//     require(gameStarted, "Game has not started");
//     require(msg.sender == players[currentPlayerIndex].playerAddress, "Not your turn");

//     uint256 rollResult = generateRandomNumber();

//     // Update current player's pawn positions based on the roll and game rules
//     // ... implement game logic here, considering safe spaces, home stretch, and potential rules like extra turns

//     // Check if the player has won
//     if (hasWon(currentPlayerIndex)) {
//         gameFinished = true;
//     } else {
//         currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
//     }
// }



    // Move the player based on the dice value
    function movePlayer(uint8 diceValue) internal {
        Player storage player = players[msg.sender];

        // If player hasn't started and rolls a 6, they start the game
        if (!player.hasStarted && diceValue == 6) {
            player.hasStarted = true;
        }

        // If the player has started, move their token
        if (player.hasStarted) {
            player.position += diceValue;

            // If the position exceeds BOARD_SIZE, reset to BOARD_SIZE (finish line)
            if (player.position >= BOARD_SIZE) {
                player.position = BOARD_SIZE; // Reached or passed the end
            }

            emit PlayerMoved(msg.sender, player.position);
        }
    }

    // Helper function to switch turns between players
    function nextPlayer() internal {
        // For simplicity, the contract assumes 2 players, Player 1 and Player 2
        // More complex turn mechanics can be added for more players

        if (currentPlayer == msg.sender) {
            currentPlayer = address(uint160(currentPlayer) ^ 0x1); // Toggle between two addresses
        }
    }

    // Check if a player has won
    function checkWinner() public view returns (bool) {
        return players[msg.sender].position == BOARD_SIZE;
    }

    function hasWon(uint256 playerIndex) private view returns (bool) {
    // Check if all pawns have reached the finish line
    for (uint256 i = 0; i < players[playerIndex].pawns.length; i++) {
        if (players[playerIndex].pawns[i] != finishLine) {
            return false;
        }
    }
    return true;
}
}
