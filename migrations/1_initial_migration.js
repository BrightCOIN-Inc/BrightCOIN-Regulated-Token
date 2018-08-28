var Migrations = artifacts.require("./Migrations.sol");
//var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
//var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 
//var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
	//deployer.deploy(BrightCoinKYCContract);
  //deployer.deploy(BrightCoinInvestorAccreditation);
  // deployer.deploy(BrightCoinRegulatedToken);
};