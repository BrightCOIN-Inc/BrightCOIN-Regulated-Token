var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Testing AutoTransfer & Token  Distribution', (accounts) => {

  let instance
  let owner = accounts[0]
  let FirstAccriditedInvestor = accounts[1]
  let NewInvestorAcridited = 0x403f4fedf6127f30e77ae8295dea47eea0832899
  let NewInvestorNonAcridited = 0x9750aa30a3281df657d8b08499e1b5dbc90e0b5f   
  let AddressWithoutKYCAccridition  = 0xdc18ee70c6215ac9c81a3f704648b8c8a6ec7201 
  let NewNonAccredetedAddress = 0x46dD52d1Ae60322C909E1dee6411AF70CD4191b3

  beforeEach(async () => {
    instancekyc = await BrightCoinKYCContract.deployed()
   instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
     instance = await BrightCoinRegulatedToken.deployed()
    
  })

  let OwnerBal1,OwnerBal2,AccountBal1,AccountBal2,NewAccountBal1,AccountBal3,currenttime,KYCCount,AccountBal4,AfterMintBal
  
  /*START...............................................................................................*/
//ADD Token for 2 Advisors and then Remove him for further Getting token then trying to give him Token
 it("IT SHOULD Do Auto Transfer", async () => {
  
    try {

    	//Set KYC Details
    	//Start
    var KYCExpiryDateTime = 1566102022;
    var ipfsHashKYC = "QmWDhue9iG8YJPh65TdD6zEYHZeeJKyVJC1e2uARwHGPC7";
     
  //instancekyc.SetKYCDetailsofInvestor(FirstAccriditedInvestor,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});
  //instancekyc.SetKYCDetailsofInvestor(NewInvestorAcridited,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});
 // instancekyc.SetKYCDetailsofInvestor(NewInvestorNonAcridited,true,KYCExpiryDateTime,ipfsHashKYC,{from: accounts[0]});
  //KYCCount = await instancekyc.GetKYCCount();

    	//End

        //Stop ICO Abruptly
       //StopICO =  await instance.StopICO(true,{from: accounts[0]});
    	//Set RegD Accredition
    	//Start
    	/* Set Accridition Details*/
      //Start
    var expiryDateRegD = 1566102022;
    var InvestorGeolocationUSA = 1;
    var InvestorGeoLocationIndia = 91;
    var ipfsHash = "QmWDhue9iG8YJPh65TdD6zEYHZeeJKyVJC1e2uARwHGPC7";
//instanceAcridetion.AddInvestorAccreditionDetails(FirstAccriditedInvestor,true,expiryDateRegD,InvestorGeolocationUSA,ipfsHash,{from: accounts[0]});
   instanceAcridetion.AddInvestorAccreditionDetails(accounts[1],true,expiryDateRegD,InvestorGeoLocationIndia,ipfsHash,{from: accounts[0]});
  instanceAcridetion.AddInvestorAccreditionDetails(accounts[2],true,expiryDateRegD,InvestorGeolocationUSA,ipfsHash,{from: accounts[0]});
    //Set GEO Location details 
     var InvestorGeoLocationne= 1;
     var BuyerGeoLocation = 91;
   //instanceAcridetion.AddNonAccredetedInvestorDetails(FirstAccriditedInvestor,InvestorGeoLocationne,ipfsHash,{from: accounts[0]} );
   //instanceAcridetion.AddNonAccredetedInvestorDetails(NewInvestorNonAcridited,InvestorGeolocationUSA,ipfsHash,{from: accounts[0]} );
      //End

//Set KYC And Acrridition detail as off

  //Set the KYC check implementation
   instance.setKYCSupport(false);
//Set the Accridition check implementation
   instance.setAccridetionSupport(false) ;


    	//End  //1534567000
    OwnerBal1 = await instance.balanceOf(owner);  //100,000
    AccountBal1  = await instance.balanceOf(accounts[2]);  //0 

    console.log(OwnerBal1,"Initial Owner Balance");
    console.log(AccountBal1," Investor1 Balance");


     //Change OwnerShip

   // OwnerShipChange =   instance.transferOwnership(accounts[2],{from: accounts[0]});

      //Now try with Prevous owner

    //OwnerShipChange1 =   instance.transferOwnership(accounts[0],{from: accounts[2]});

    var OwnerAddr1 = await instance.owner();
    console.log(OwnerAddr1,"Owner Addres before Transfer");
    console.log(accounts[0],"Owner Addres before Transfer from Accounts" );

    OwnerShipChange =  await  instance.transferOwnership(accounts[2],{from: accounts[0]});

    OwnerShipChange =  await  instance.transferOwnership(accounts[0],{from: accounts[2]});

    var OwnerAddr2 = await instance.owner();
    console.log(OwnerAddr2,"Owner Addres after Transfer");
    console.log(accounts[2],"Owner Addres after Transfer from Accounts2" );



    Transaction1  = await instance.sendTransaction({from:accounts[1],value:(2)*10**18});
    
    //First datetime is current time and other id lock expiry
    DistributeToken = await instance.DistributeToken(accounts[1],1536205322,1536566551,0,{from: accounts[0]});

   AccountBal2  = await instance.balanceOf(accounts[1]);  //2000
    OwnerBal2  = await instance.balanceOf(accounts[0]);    //980000
    
   console.log(AccountBal2,"Investor1 balance Post Auto Transfer");
    console.log(OwnerBal2,"Owner Balance Post Auto Transfer");

    //Now Transfer this token to New Investor	

   //NewTransfer   = instance.transfer(accounts[1],50*(10**18) ,{from: accounts[1]});
   //NewAccountBal1  = await instance.balanceOf(accounts[2]);
   //AccountBal3  = await instance.balanceOf(accounts[1]);
  
   //console.log(NewAccountBal1," new Investor in New Account");
   //console.log(AccountBal3," Investor balance post Transfer");



    } 
    catch (e) {
      console.log(e + ` Exception Test Auto Transfer`)
    }



 
    })

/*END.............................................................................................*/



})