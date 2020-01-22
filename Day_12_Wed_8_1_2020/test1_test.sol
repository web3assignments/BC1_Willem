pragma solidity >=0.5.0 <0.6.0;
    import "remix_tests.sol"; // this import is automatically injected by Remix.
    import "./WhatAreTheOdds_members.sol";
    
    
    // file name has to end with '_test.sol'
    contract test_1 {
          WhatAreTheOdds testing;

        function beforeAll() public {
            testing = new WhatAreTheOdds();
        }
        
        function check1() public {
          // use 'Assert' to test the contract
          Assert.equal(uint(2), uint(2), "error message");
        }
        
        function StartWithoutMemebers() public{
            Assert.equal(testing.isMember(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c), false, "Is a member");
        }
        
        function addMember() public{
            testing.addMember(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
            Assert.equal(testing.isMember(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c), true, "is not a member");
        }
        
        function TestInputOdds1() public{
            
            testing.GiveTheOddsPlayerOne(5, 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
            testing.GuessNumberOne(5);
            Assert.equal(testing.GuessNumberTwo(5), 1, "The winner should be player 1");
            
        }
        
        function TestListLength() public{
            Assert.equal(testing.List1Length(), 1, "Wrong List Length");
        }
        


      }
