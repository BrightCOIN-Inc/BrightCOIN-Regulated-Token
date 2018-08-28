var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Main Sale Testing for Regulated Token', (accounts) => {

  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
    //instancekyc = await BrightCoinKYCContract.deployed()
    //instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
     instance1 = await BrightCoinRegulatedToken.deployed()
    
  })

  /*START...............................................................................................*/
//ADD Token for 2 Advisors and then Remove him for further Getting token then trying to give him Token
 it("IT SHOULD Add or Remove Main Sale Details", async () => {
   let  MainSale1,MainSale2,TotalMainSaleCount,BonusDetails,EndMainSale
    try {

/*Set Token Amount for main Sale */
      var mainStartDate1 = 1534940356;
      var mainSaleEndDate1 = 1545481156;
      var MaCoinSold = 10000;
      var BonusDuringMainsale1 = 5000;
      var TokenLockinPerod1 = 1540000000;
      var PeriodActive1 = 1;
      var PeriodIndex1 = 0;


      var mainStartDate2 = 1534940356;
      var mainSaleEndDate2 = 1545481156;
      var MaCoinSol2 = 10000;
      var BonusDuringMainsale2 = 2000;
      var TokenLockinPerod2 = 1540000000;
      var PeriodActive2 = 1;
      var PeriodIndex2 = 1;


   

  MainSale1 = await instance1.AddMainSalePeriod(mainStartDate1,mainSaleEndDate1,TokenLockinPerod1,
                                                MaCoinSold,BonusDuringMainsale1,PeriodIndex1,
                                                PeriodActive1,{from: accounts[0]} );

   MainSale2 = await instance1.AddMainSalePeriod(mainStartDate2,mainSaleEndDate2,TokenLockinPerod2,
                                                MaCoinSol2,BonusDuringMainsale2,PeriodIndex2,
                                                PeriodActive2,{from: accounts[0]} );
 

     
    TotalMainSaleCount =  await instance1.MainSaleCount();  //Total Main Sale Details

    BonusDetails = await instance1.GetBonusDetails(PeriodActive2,{from: accounts[0]});  //Find our bonus detils per period

    EndMainSale = await instance1.EndMainSale(PeriodIndex2,{from: accounts[0]});

    MainSaleStatus = await instance1.CheckIfMainSaleOn(PeriodIndex2);

    //,{from: accounts[0]}
    } 
    catch (e) {
      console.log(` Exception in Main Sale`)
    }
  //console.log(MainSale1);
  // console.log(MainSale2);
  console.log("MAINSALE LOG STARTS");
  console.log(TotalMainSaleCount, "Total Main Sale Count");
  console.log(BonusDetails, " Bonus Details");
  console.log(EndMainSale,"Changed Main Sale Status");
  console.log(MainSaleStatus,"MainSaleStatus");

 
    })

/*END.............................................................................................*/



})