pragma solidity >=0.5.0 <0.7.0;

/// @title What are the odds?
/// @author Willem vand der Gaag
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects

contract WhatAreTheOdds{
    
/// @author Willem van der Gaag
/// @notice Player 1 first has to give the odds, with a maximum of int1
/// @notice Player 1 has to guess a number between 0 and the odds
/// @notice Player 2 has to guess a number between 0 and the odds
/// @notice If Player 1 and 2 both guess the same number, Player 1 wins
/// @notice Otherwise Player 2 wins
/// @dev this is the application in it's most basic form
/// @return GuessNumberTwo, winner of the game
/// @return List1Length, number of guesses player 1
/// @return List2Length , number of guesses player 2

    event Log(string message, uint guess);   // declaring event  
  	uint public odds;
	uint public guessOne;
  	uint public guessTwo;
  	uint public winner;
  	uint public winsPlayerOne;
  	uint public winsPlayerTwo;
    constructor() public payable {}
  	
    struct member {
        uint data;
    }
    
    member[] public GuessedOddsPlayer1;
    member[] public GuessedOddsPlayer2;
    
    /// @param GiveOdds, starting odds, int between 0 and 10
    function GiveTheOddsPlayerOne(uint GiveOdds) public  { 
        odds=GiveOdds;
        require(odds < 11, "Odds too high");
        require(odds > 1, "odds have to be above 2");
        emit Log("The odds are", odds);
    }
    
  	/// @param FirstOdds, int between 0 and odds, player one's guess
  	function GuessNumberOne(uint FirstOdds) public {
  	    uint list1 = List1Length();
        uint list2 = List2Length();
        require(list1 == list2, "Not your turn");
       	guessOne =FirstOdds;
      	require(odds > 0, "No odds given");
      	require(guessOne <= odds,"Has to be lower than the odd");
        member memory temp;
        temp.data=FirstOdds;
        GuessedOddsPlayer1.push(temp);

      	emit Log("Player one guessed: ", guessOne);
    }
    
    /// @param SecondOdds, int between 0 and odds, player two's guess
    function GuessNumberTwo(uint SecondOdds) public returns(uint) {
        uint list1 = List1Length();
        uint list2 = List2Length();
        require(list1 == list2 + 1, "Not your turn");
        guessTwo =SecondOdds;
        require(odds > 0, "No odds given");
      	require(guessTwo <= odds,"Has to be lower than the odd");
      	member memory temp;
        temp.data=SecondOdds;
        GuessedOddsPlayer2.push(temp);
      	emit Log("Player two guessed: ", guessTwo);
      	
      	if(guessTwo == guessOne){
      	    winner = 1;
            winsPlayerOne++;
            emit Log("Won by player: ", winner);
        }
      	else{
            winner = 2;
            winsPlayerTwo++;
            emit Log("Won by player: ", winner);
        }
        return winner;
    }
    
    function List1Length() public view returns(uint) {
      return GuessedOddsPlayer1.length;
    }
    
    function List2Length() public view returns(uint) {
      return GuessedOddsPlayer2.length;
    }
    
}
