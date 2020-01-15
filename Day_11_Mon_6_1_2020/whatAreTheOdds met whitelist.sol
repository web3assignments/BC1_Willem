pragma solidity ^0.5.12;

import "github.com/provable-things/ethereum-api/provableAPI.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";


contract WhatAreTheOdds is usingProvable, Ownable {

    event Log(string message, uint guess);   // declaring event  
  	uint public odds;
	uint public guessOne;
  	uint public guessTwo;
  	uint public winner;
  	uint public winsPlayerOne;
  	uint public winsPlayerTwo;
  	string public dateTime;
  	uint256 public priceOfUrl;
    constructor() public payable {}
  	
    struct member {
        uint data;
    }
    
    member[] public GuessedOddsPlayer1;
    member[] public GuessedOddsPlayer2;
  
    function GiveTheOddsPlayerOne(uint GiveOdds, address _member) public  { 
        require(
            isMember(_member),
            "Address is not a member"
        );
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

   function __callback(bytes32 myid, string memory result ) public {
       if (msg.sender != provable_cbAddress()) revert();
       dateTime = result;
    }
    
    function GetDateTime() public payable {
       priceOfUrl = provable_getPrice("URL");
       require (address(this).balance >= priceOfUrl,
            "please add some ETH to cover for the query fee");
       provable_query("URL", 
            "json(http://worldtimeapi.org/api/timezone/Europe/Amsterdam).datetime");
   }
    event MemberAdded(address member);
    event MemberRemoved(address member);

    mapping (address => bool) members;

    /**
     * @dev The contract constructor.
     */
    // constructor() public Ownable() {
    // }

    /**
     * @dev A method to verify whether an address is a member of the whitelist
     * @param _member The address to verify.
     * @return Whether the address is a member of the whitelist.
     */
    function isMember(address _member)
        public
        view
        returns(bool)
    {
        return members[_member];
    }

    /**
     * @dev A method to add a member to the whitelist
     * @param _member The member to add as a member.
     */
    function addMember(address _member)
        public
        onlyOwner
    {
        require(
            !isMember(_member),
            "Address is member already."
        );

        members[_member] = true;
        emit MemberAdded(_member);
    }

    /**
     * @dev A method to remove a member from the whitelist
     * @param _member The member to remove as a member.
     */
    function removeMember(address _member)
        public
        onlyOwner
    {
        require(
            isMember(_member),
            "Not member of whitelist."
        );

        delete members[_member];
        emit MemberRemoved(_member);
    }
}
