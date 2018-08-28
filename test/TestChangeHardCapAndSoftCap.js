
//var MyContract = artifacts.require("MyContract")
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('HardCap & SoftCap Testing for Regulated Token', (accounts) => {

  let instance
  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
     instance = await BrightCoinRegulatedToken.deployed()
    
  })


/*START...............................................................................................*/
//Increase HardCap and then Transfer

let  balanceHardCap, boolHardCap 

   it("IT SHOULD Increased hardcap and then Allow Transfer FOR KYC AND ACCRIDITION REGAplus THEN TRANSFER MONEY", async () => {
    try {

      //Now Please increase hard Cap so the More token can be provided 
     boolHardCap = await instance.ChangeHardCap(700000,{from: accounts[0]});


      balanceHardCap = await instance.GetHardCap();
    // boolvalHardcap = await instance.RegulatedTokenTransferToInvestor(InvestordAddress,currenttime,2,token, {from: accounts[0]});

    } catch (e) {
      console.log(`Exception Thrown`)
    }
   console.log(boolHardCap);
    console.log(balanceHardCap);
    
  })

/*END...............................................................................................*/
})
