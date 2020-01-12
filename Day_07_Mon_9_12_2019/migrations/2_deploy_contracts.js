var HelloWorld = artifacts.require("HelloWorld");
var WhatAreTheOdds = artifacts.require("WhatAreTheOdds");
module.exports = function(deployer) {
    deployer.deploy(HelloWorld);
	deployer.deploy(WhatAreTheOdds);

    // Additional contracts can be deployed here
};