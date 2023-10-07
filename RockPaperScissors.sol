// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    address public owner;
    uint256 public minimumBet = 0.0001 ether;

    enum Move { Rock, Paper, Scissors }
    enum Result { None, Player1Wins, Player2Wins, Draw }

    struct Game {
        address player1;
        address player2;
        Move move1;
        Move move2;
        uint256 bet;
        Result result;
    }

    Game[] public games;
    mapping(address => uint256[]) public playerGames;

    event NewGame(uint256 gameId, address player1, address player2, uint256 bet);
    event GameResult(uint256 gameId, address winner, uint256 reward);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

function play(uint8 _move) public payable {
    require(msg.value >= minimumBet, "Insufficient bet amount");
    require(_move >= 0 && _move <= 2, "Invalid move"); // Check if the move is valid (0 = Rock, 1 = Paper, 2 = Scissors)
    uint8 randomMove = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 3); // Generate a random move (0, 1, or 2)

    // Implement game logic to determine the winner randomly.
    // Compare _move with randomMove to determine the result.
    // Store the game result and update player balances.
    // Emit GameResult event.

    // Example game logic (replace with your actual logic):
    Result result;
    if (_move == uint8(Move.Rock) && randomMove == uint8(Move.Scissors) ||
        _move == uint8(Move.Paper) && randomMove == uint8(Move.Rock) ||
        _move == uint8(Move.Scissors) && randomMove == uint8(Move.Paper)) {
        result = Result.Player1Wins;
    } else if (_move == randomMove) {
        result = Result.Draw;
    } else {
        result = Result.Player2Wins;
    }

    // Update the game result and emit the event.
    games.push(Game(msg.sender, address(0), Move(_move), Move(randomMove), msg.value, result));
    emit GameResult(games.length - 1, msg.sender, calculateReward(result, msg.value));
}


function calculateReward(Result result, uint256 bet) internal pure returns (uint256) {
    if (result == Result.Player1Wins) {
        return bet * 2;
    } else if (result == Result.Player2Wins) {
        return 0;
    } else {
        return bet;
    }
}


    function getGameCount() public view returns (uint256) {
        return games.length;
    }
}
