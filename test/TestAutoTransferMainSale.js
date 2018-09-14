var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Testing AutoTransfer & Token  Distribution', (accounts) => {

   let instance
  let owner = accounts[0]
  let account = accounts[1]
  let NewOwner = 0x403f4fedf6127f30e77ae8295dea47eea0832899

  beforeEach(async () => {
    instancekyc = await BrightCoinKYCContract.deployed()
   instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
     instance = await BrightCoinRegulatedToken.deployed()
    
  })

  let OwnerBal1,OwnerBal2,AccountBal1,AccountBal2,NewAccountBal1,AccountBal3,currenttime,KYCCount,AccountBal4,AfterMintBal,MainSale1,MainSale2
  
  /*START...............................................................................................*/
//ADD Token for 2 Advisors and then Remove him for further Getting token then trying to give him Token
 it("IT SHOULD Do Auto Transfer in MainSale", async () => {
  
    try {



/*Set Token Amount for main Sale */
      var mainStartDate1 = 1536061800;
      var mainSaleEndDate1 = 1536977396;
      var MaCoinSold = 10000*(10**18);
      var BonusDuringMainsale1 = 5000;
      var TokenLockinPerod1 = 1540000000;
      var PeriodActive1 = 1;
      var PeriodIndex1 = 1;


      var mainStartDate2 = 1537063796;
      var mainSaleEndDate2 = 1538273396;
      var MaCoinSol2 = 10000*(10**18);
      var BonusDuringMainsale2 = 0;
      var TokenLockinPerod2 = 1540000000;
      var PeriodActive2 = 1;
      var PeriodIndex2 = 2;


   

  MainSale1 = await instance.AddMainSalePeriod(mainStartDate1,mainSaleEndDate1,TokenLockinPerod1,
                                                MaCoinSold,BonusDuringMainsale1,PeriodIndex1,
                                                PeriodActive1,{from: accounts[0]} );

   MainSale2 = await instance.AddMainSalePeriod(mainStartDate2,mainSaleEndDate2,TokenLockinPerod2,
                                                MaCoinSol2,BonusDuringMainsale2,PeriodIndex2,
                                                PeriodActive2,{from: accounts[0]} );
    	//Set KYC Details
    	//Start
       var KYCExpiryDateTime = 1566102022;
       var ipfsHashKYC = "QmWDhue9iG8YJPh65TdD6zEYHZeeJKyVJC1e2uARwHGPC7";
     
   instancekyc.SetKYCDetailsofInvestor(account,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});
   instancekyc.SetKYCDetailsofInvestor(NewOwner,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});

   KYCCount = await instancekyc.GetKYCCount();

    	//End


       //make sure Presale is off 
       StopPreSale =  await instance.changePresaleStatus(false,{from: accounts[0]});

        //Stop ICO Abruptly
      StopICO =  await instance.StopICO(true,{from: accounts[0]});



      //End Main sale Abruptly
      //StopMainSale=  await instance.EndMainSale(2);
       
    	//Set RegD Accredition
    	//Start
    	/* Set Accridition Details*/
      //Start
      var expiryDateRegD = 1566102022;
     var InvestorGeolocation = 1;
      var ipfsHash = "QmWDhue9iG8YJPh65TdD6zEYHZeeJKyVJC1e2uARwHGPC7";
     instanceAcridetion.AddInvestorAccreditionDetails(account,true,expiryDateRegD,InvestorGeolocation,ipfsHash,{from: accounts[0]});
     instanceAcridetion.AddInvestorAccreditionDetails(NewOwner,true,expiryDateRegD,InvestorGeolocation,ipfsHash,{from: accounts[0]});
      //End
    	//End  //1534567000
    currenttime  = await instance.GetCurrentTime();
    OwnerBal1 = await instance.balanceOf(owner);
    AccountBal1  = await instance.balanceOf(account); 
   Transaction1  = await instance.sendTransaction({from:account,value:(0.5)*10**18});
    
    DistributeToken = await instance.DistributeToken(account,currenttime,1536977396,2,{from: accounts[0]});

  AccountBal2  = await instance.balanceOf(account);
   OwnerBal2  = await instance.balanceOf(owner);
    

    //Now Transfer this token to New Investor	

 //NewTransfer   = instance.transfer(NewOwner,50*(10**18) ,{from: accounts[1]});
 //NewAccountBal1  = await instance.balanceOf(NewOwner);
  // AccountBal3  = await instance.balanceOf(account);
  


  //Now Mint the token

    //  mint = await instance.mint(owner,2000*(10**18),{from: accounts[0]});
    //  AfterMintBal = await instance.balanceOf(owner);


   //Now Test Burn Token
    // burn = await instance.burn(1000000*(10**18),{from: accounts[0]});
    //  AccountBal4  = await instance.balanceOf(owner);


    } 
    catch (e) {
      console.log(` Exception Test Auto Transfer`)
    }
    console.log(currenttime,"currenttime");
   console.log(OwnerBal1,"OwnerBal1");
   console.log(AccountBal1,"AccountBal1");
  console.log(AccountBal2, "AccountBal2");
  console.log(OwnerBal2, "OwnerBal2");
  //  console.log(NewAccountBal1,"NewAccountBal1");
  //console.log(AccountBal3,"AccountBal3");



   
 

 
    })

/*END.............................................................................................*/



})