var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('BrightCoinRegulatedTokenForMainsale', (accounts) => {

  let instance
  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
  
     instance = await BrightCoinRegulatedToken.deployed()
    
  })


/*START...............................................................................................*/
//Check PreSale Date & Time & Change Start DateTime

let  ChangePreSaleEdDate,ChangePreSaleStartDate,InPreSalePeriod
   it("IT Check Minium and Maximum Contribution Limit", async () => {
    let  InPreSalePeriod,ChangePreSaleStartDate,ChangePreSaleEdDate
    try {


//1536545897
      //Check if Current time is inPreSale
    InPreSalePeriod = await instance.inPreSalePeriod(1536545900);

     //Now Change Current PreSale Start Date & End Time.
   ChangePreSaleStartDate = await instance.changeStartDate(1536545500,{from: accounts[0]});

    //Now Change Current PreSale Start Date & End Time.
 //  ChangePreSaleEdDate = await instance.changeEndDate(1545482000,{from: accounts[0]});

 
    
    } catch (e) {
      console.log(`Exception Thrown For PreSale ChangeDate`);
    }
  
    console.log(InPreSalePeriod , "InPreSalePeriod");
    console.log(ChangePreSaleStartDate ,"ChangePreSaleStartDate");
    console.log(ChangePreSaleEdDate , "ChangePreSaleEdDate");

})
   
    
  })

/*END.............................................................................................*/
