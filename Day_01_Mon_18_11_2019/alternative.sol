
pragma solidity >=0.5.0 <0.7.0;

contract WhatAreTheOdds {

    event NewOdds(uint odd)  ;   // declaring event  
  	event Odds1(uint odd1);
  	event Odds2(uint odd2);
  	uint public odds;
		uint public guessOne;
  	uint public guessTwo;
  	uint public winner;
  
    function GiveTheOdds(uint g) public  { // returning value isn't easy to retreive
        odds=g;
        require(odds < 11, "Odds too high");

        emit NewOdds(odds);
    }
  	
  	function GuessNumberOne(uint g) public {
       	guessOne =g;
      	require(guessOne <= odds,"Has to be lower than odd");
 
      	emit Odds1(guessOne);
    }
    function GuessNumberTwo(uint g) public returns(uint) {
        guessTwo =g;
      	require(guessTwo <= odds,"Has to be lower than odd");
      
      	if(guessTwo == guessOne){
          winner = 1;
        }
      	else{
          winner = 2;
        }
     		emit Odds2(guessTwo);
        return winner;
    }
  
}
