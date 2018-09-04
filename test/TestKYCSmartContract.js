//var MyContract = artifacts.require("MyContract")
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Testing KYC Setup', (accounts) => {

   let instance
  let owner = accounts[0]
  let account = accounts[1]
  let NewOwner = 0x403f4fedf6127f30e77ae8295dea47eea0832899
  //let newAccount = 0x403f4fedf6127f30e77ae8295dea47eea0832899;

  beforeEach(async () => {
    instancekyc = await BrightCoinKYCContract.deployed()
   instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
     instance = await BrightCoinRegulatedToken.deployed()
    
  })

  let KYC1, KYC2, KYCCount,KYCExpiryDate
  
  /*START...............................................................................................*/
//ADD Token for 2 Advisors and then Remove him for further Getting token then trying to give him Token
 it("IT SHOULD Do Auto Transfer", async () => {
  
    try {

    	//Set KYC Details
    	//Start
       var KYCExpiryDateTime = 1566102022;
       var ipfsHashKYC = "QmWDhue9iG8YJPh65TdD6zEYHZeeJKyVJC1e2uARwHGPC7";
     // var InvestordAddress = 0x9750aa30a3281dF657d8B08499e1b5Dbc90e0b5f;
    instancekyc.SetKYCDetailsofInvestor(account,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});
   instancekyc.SetKYCDetailsofInvestor(NewOwner,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});

   KYCCount = await instancekyc.GetKYCCount();
   KYCExpiryDate = await instancekyc.GetKYCExpiryDate(account);

    	//End




    } 
    catch (e) {
      console.log(` Exception Test Auto Transfer`)
    }

  console.log(KYCCount,"KYC Count");
  console.log(KYCExpiryDate, "KYC Expiry Date");

   
   
   

 
    })

/*END.............................................................................................*/



})