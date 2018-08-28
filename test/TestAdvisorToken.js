

//var MyContract = artifacts.require("MyContract")
var BrightCoinRegulatedToken = artifacts.require("./contracts/BrightCoinRegulatedToken.sol");
var BrightCoinKYCContract = artifacts.require("./contracts/BrightCoinInvestorKYC.sol"); 
var BrightCoinInvestorAccreditation = artifacts.require("./contracts/BrightCoinInvestorAccreditationCheck.sol"); 


//Check BalanceOF method for Different accounts.
contract('Regulated token can sey multiple Advisors', (accounts) => {

  let owner = accounts[0]
  let account = accounts[1]

  beforeEach(async () => {
    //instancekyc = await BrightCoinKYCContract.deployed()
    //instanceAcridetion = await BrightCoinInvestorAccreditation.deployed()
        instance = await BrightCoinRegulatedToken.deployed()
    
  })


/*START...............................................................................................*/
//ADD Token for 2 Advisors and then Remove him for further Getting token then trying to give him Token

let  advisortoken1, advisorcount1 , amountAdv1,advisortoken2,advisorcount2,amountAdv2,RemoveAdvisor,CheckIfAdvActive,AddAmounttoRemovedAdvisor,çheckAgainWhetherAmountUpdated

   it("IT SHOULD Increased hardcap and then Allow Transfer FOR KYC AND ACCRIDITION REGAplus THEN TRANSFER MONEY", async () => {
    try {


      /*Set Token Amount to Advisor */
      var Address1 = 0x195febD21825622f30FB8ff2F81f83d98b28a4A6;
      var LockStartTime1 = 1533917825;
      var LockExpiryTime1 = 1544458590
      var partofTeam1 = 1;
      var Amount1 = 40000;

      var Address2 = 0xcf530e5b154EB28A379cF5774d5d15B04cF10422;
      var LockStartTime2 = 1533917825;
      var LockExpiryTime2 = 1544458590
      var partofTeam2 = 1;
      var Amount2  = 20000;
       

     advisortoken1 = await instance.AddAdvisor(Address1,Amount1,LockStartTime1,LockExpiryTime1,
                                         partofTeam1,{from: accounts[0]} );
     advisorcount1 = await instance.TotalAdvisor();

     amountAdv1 = await instance.CheckAdvisorTokenAmount(Address1);

     advisortoken2 = await instance.AddAdvisor(Address2,Amount2,LockStartTime2,LockExpiryTime2,
                                             partofTeam2,{from: accounts[0]} );
      advisorcount2 = await instance.TotalAdvisor();

      amountAdv2 = await instance.CheckAdvisorTokenAmount(Address2);
       
       //Remove Advisor from further investment

       RemoveAdvisor = await instance.RemoveAdvisorFromFurtherInvestment(Address2,{from: accounts[0]});


       var Amount3  = 10000;
     CheckIfAdvActive = await instance.CheckIfAdvisorActive(Address2);

     //It must throw Exception
    AddAmounttoRemovedAdvisor = await instance.AddAdvisor(Address2,Amount3,LockStartTime2,LockExpiryTime2,partofTeam2,{from: accounts[0]});
   çheckAgainWhetherAmountUpdated = await instance.CheckAdvisorTokenAmount(Address2,{from: accounts[0]} );  
                                  
        
    
    } catch (e) {
      console.log(`Exception Thrown For Advisor`)
    }

   console.log(advisortoken1, "Advisor1 Added");
   console.log(advisorcount1, "Count Check after Advisor1");
   console.log(amountAdv1, "Check Token Amount of Advisor");
  console.log(advisortoken2, "Advisor2 Added");
   console.log(advisorcount2, "Count check after Advisor2");
   console.log(amountAdv2, "AmountCheck After Advisor2");
   console.log(RemoveAdvisor, "Remove Advisor");
   console.log(CheckIfAdvActive,"Check if Advisor Active");
   console.log(AddAmounttoRemovedAdvisor,"AddAmounttoRemovedAdvisor");
   console.log(çheckAgainWhetherAmountUpdated,"çheckAgainWhetherAmountUpdated");
   
 
    
  })

/*END.............................................................................................*/

})
