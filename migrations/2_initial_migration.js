
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");



module.exports = async function(deployer) {


let Instkyc, InstAccredition, instToken;

 deployinstance = await Promise.all([
 deployer.deploy(BrightCoinKYCContract),
 deployer.deploy(BrightCoinInvestorAccreditation),
 deployer.deploy(BrightCoinRegulatedToken)

]);

 console.log(deployinstance);

//Wait Till KYC Contract get Deployed
instances = await Promise.all([
BrightCoinKYCContract.deployed()

]);

Instkyc = instances[0];

//Wait Till Accreditation Contract get Deployed
instances = await Promise.all([
BrightCoinInvestorAccreditation.deployed()

]);

InstAccredition = instances[0];

//Wait Till RegulatedToken Contract get Deployed
instances = await Promise.all([
BrightCoinRegulatedToken.deployed()
]);

instToken = instances[0];

 

 //Set the Address of contracts to the Regulated contracts.
results = await Promise.all([
  BrightCoinRegulatedToken.address = instToken.address,
 instToken.setKYCAndAccridetionAddres(Instkyc.address,InstAccredition.address) 
]);

};





