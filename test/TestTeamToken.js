//var MyContract = artifacts.require("MyContract")
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Regulated token Setting for Team', (accounts) => {

  let instance
  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
  
        instance = await BrightCoinRegulatedToken.deployed()   
  })


  /*START...............................................................................................*/
//ADD Token for 2 Team and then Remove him for further Getting token then trying to give him Token
 it("Regulated Token can set multiple Team ", async () => {
   let  Teamtoken1, Teamcount1,TeamAmount1,Teamtoken2,Teamcount2,TeamAmount2,RemovedTeam,
                    CheckifTeamActive,AddTeamPostDeactivation,TeamAmountPostDeactivation
    try {

/*Set Token Amount to Advisor */
      var TAddress1 = 0x195febD21825622f30FB8ff2F81f83d98b28a4A7;
      var TLockStartTime1 = 1533917825;
      var TLockExpiryTime1 = 1544458590
      var TpartofTeam1 = 1;
      var TAmount1 = 5000;

      var TAddress2 = 0xcf530e5b154EB28A379cF5774d5d15B04cF10423;
      var TLockStartTime2 = 1533917825;
      var TLockExpiryTime2 = 1544458590
      var TpartofTeam2 = 1;
      var TAmount2  = 20000;
      
   

      //Team 1
    Teamtoken1 = await instance.AddTeamInvestor(TAddress1,TAmount1,
                                                TLockStartTime1,TLockExpiryTime1,
                                                 TpartofTeam1,{from: accounts[0]});

     Teamcount1 = await instance.TotalTeamnvestor();

     TeamAmount1 = await instance.CheckTeamTokenAmount(TAddress1);

     //Team 2

     Teamtoken2 = await instance.AddTeamInvestor(TAddress2,TAmount2,
                                                TLockStartTime2,TLockExpiryTime2,
                                                TpartofTeam2,{from: accounts[0]});

      Teamcount2 = await instance.TotalTeamnvestor();

      TeamAmount2 = await instance.CheckTeamTokenAmount(TAddress2);
       
       //Remove Team for further investment

    // RemovedTeam = await instance.RemoveTeamFromFurtherInvestment(TAddress2);


    var TAmount3  = 10000;
     CheckifTeamActive = await instance.CheckIfTeamActive(TAddress2);

     AddTeamPostDeactivation = await instance.AddTeamInvestor(TAddress2,TAmount3,
                                                    TLockStartTime2,TLockExpiryTime2,
                                                    TpartofTeam2,{from: accounts[0]});
     
      TeamAmountPostDeactivation = await instance.CheckTeamTokenAmount(TAddress2);
                                
        
    

    } catch (e) {
      console.log(`Team Token Throw Exception`)
    }

  console.log(Teamtoken1,"Add Team token1");
  console.log(Teamcount1 , " TeamCount1");
  console.log(TeamAmount1 , " Team Amount1");
  console.log(Teamtoken2,"Add Team token2");
  console.log(Teamcount2, "Add Team token2");
  console.log(TeamAmount2, "Amount of Team2");
  console.log(RemovedTeam, "Removed one of the Team ");
  console.log(CheckifTeamActive, "CheckifTeamActive post Removal");
  console.log(AddTeamPostDeactivation,"AddTeamPostDeactivation");
  console.log(TeamAmountPostDeactivation,"TeamAmountPostDeactivation");

    })

/*END.............................................................................................*/

})

