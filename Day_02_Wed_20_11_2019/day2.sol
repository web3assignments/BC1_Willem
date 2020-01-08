pragma solidity >=0.5.0 <0.7.0;

contract WhatAreTheOdds {

    event Log(string message, uint guess);   // declaring event  
  	uint public odds;
	uint public guessOne;
  	uint public guessTwo;
  	uint public winner;
  	uint public winsPlayerOne;
  	uint public winsPlayerTwo;
  	
    struct member {
        uint data;
    }
    
    member[] public GuessedOddsPlayer1;
    member[] public GuessedOddsPlayer2;
  
    function GiveTheOddsPlayerOne(uint GiveOdds) public  { 
        odds=GiveOdds;
        require(odds < 11, "Odds too high");
        require(odds > 1, "odds have to be above 2");
        emit Log("The odds are", odds);
    }
  	
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

    
    mapping(address => uint) public currentGuess;  
    
    function guessedWinner(address _addr) public view returns (uint){      // call via an address which person is expected to win
        return currentGuess[_addr];
    }
    
    function guessAWinner(address _address, uint _guess) public {           // save via an address who you expect to win
        currentGuess[_address] = _guess;
    }

}
