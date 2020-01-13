pragma solidity >=0.5.0 <0.7.0;
import "github.com/provable-things/ethereum-api/provableAPI.sol";


contract WhatAreTheOdds is usingProvable {

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
   
    string public name="Initial";

    function SetName(string memory NewName) public {
        name = NewName;
    }
    function destroy() public  {
        selfdestruct(msg.sender);
    }
    function destroyAndSend(address payable recipient) public  {
        selfdestruct(recipient);
    }
}

contract Factory {
    bytes mmcode= type(WhatAreTheOdds).creationCode;
    WhatAreTheOdds public deployedWhatAreTheOdds;

    function NameDeployedWhatAreTheOddsl() public view returns (string memory) {
        return deployedWhatAreTheOdds.name();
    }
    function DestroyDeployedWhatAreTheOdds() public {
        deployedWhatAreTheOdds.destroy();
    }
    function DeployViaCreate() public returns (WhatAreTheOdds){
        deployedWhatAreTheOdds=WhatAreTheOdds(Create(mmcode));
        deployedWhatAreTheOdds.SetName("Created via create");
        return deployedWhatAreTheOdds;
    }
    function Create(bytes memory code) private returns(address addr) {   
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }
    }
    function DeployViaCreate2() public returns (WhatAreTheOdds){
        deployedWhatAreTheOdds=WhatAreTheOdds(Create2(mmcode,0x00));
        deployedWhatAreTheOdds.SetName("Created via create2");
        return deployedWhatAreTheOdds;
    }
    function Create2(bytes memory code, bytes32 salt) 
        private returns(address addr) {
        assembly {
            addr := create2(0, add(code, 0x20), mload(code), salt)
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }
    }
}
