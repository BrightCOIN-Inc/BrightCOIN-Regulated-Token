//var MyContract = artifacts.require("MyContract")
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Start Date & End Date Testing', (accounts) => {

  let instance, balance, balance1, boolval, instancekyc,boolvalRegu, instanceAcridetion
  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
    instancekyc = await BrightCoinKYCContract.deployed()
    instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
     instance = await BrightCoinRegulatedToken.deployed()
    
  })


})