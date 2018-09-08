
pragma solidity ^0.4.24;

import "./BrightCoinTeamTokenDistribution.sol"; 
import "./BrightCoinFounderTokenDistribution.sol"; 
import "./BrightCoinAdvisorTokenDistribution.sol"; 

import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";

contract BrightCoinTokenDistributionDetails is BrightCoinTokenOwner, BrightCoinAdvisorTokenDistribution,BrightCoinTeamTokenDistribution,BrightCoinFounderTokenDistribution
{

using SafeMath for uint;
address owner;
constructor(address _owner) public
{
  owner = _owner;
}


//Team Token Distribution  Starts

//Addng Details to Team Token
 function AddTeamInvestor(address NewTeamAddr,uint256 Tokenamount,uint256 TokenLockStartDateTime,uint256 TokenLockEndDateTime, bool partofTeam) onlyTokenOwner(owner)   public {
     
  require(IsTokenAvailable(Tokenamount) == true);
  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
 // require(TeamDetails.partOfTeam == true);

  if(TeamDetails.TeamDistributionIndex == false) //New Team
  {
    TeamDetails.TeamDistributionAddress = NewTeamAddr;
    TeamDetails.TeamDistributionAmount = Tokenamount;
    TeamDetails.TeamDistributionAmountLockStatrDateTime = TokenLockStartDateTime;
    TeamDetails.TeamDistributionAmountLockExpiryDateTime = TokenLockEndDateTime;
    TeamDetails.TeamActiveInvestor = partofTeam;
    TeamDetails.TeamDistributionIndex = true;
    TeamTokenDetailsAddr.push(NewTeamAddr);
  }
  else
  {
      //check if Team is Active
      require(CheckIfTeamActive(NewTeamAddr) == true);
      TeamDetails.TeamDistributionAmount += Tokenamount;
      TeamDetails.TeamDistributionAmountLockStatrDateTime = TokenLockStartDateTime;
      TeamDetails.TeamDistributionAmountLockExpiryDateTime = TokenLockEndDateTime;
  }
  
 }

//ENDS


//Add Founder Starts

function AddNewFounder(address newFounder,uint256 FounderToken,uint256 LockExpiryDateTime, bool FounderPartofTeam)    onlyTokenOwner(owner)   public 
  {

      require(TokenAvailableForFounder(FounderToken) == true);

        FounderDistribution storage  FounderDetails = FounderTokenDetails[newFounder];

        if(FounderDetails.FounderIndex == false)
        {

         FounderDetails.FounderAddress = newFounder;
         FounderDetails.FounderToken = FounderToken;
         FounderDetails.LockExpiryTime = LockExpiryDateTime;
        FounderDetails.FounderActive = FounderPartofTeam;
         FounderDetails.FounderIndex = true;
          FounderAddrs.push(newFounder);
       }
       else
        {
          require(CheckIfFounderActive(newFounder) == true);
                    
            //Add new Token amount and Set new locking Period
           FounderDetails.FounderToken  = FounderDetails.FounderToken.add(FounderToken);
            FounderDetails.LockExpiryTime = LockExpiryDateTime;
        }
 
 }


 

//ENDS


//Advisor Starts
//Adding New Advisor for Token Distribution
 function AddAdvisor(address NewAdvisor,uint256 Tokenamount,uint256 lockStartTime,
                    uint256 LockExpiryTime, bool PartofTeam)  onlyTokenOwner(owner)  public
  {
       require(TokenAvailableForAdvisor(Tokenamount) == true);

        AdvisorDistribution storage  AdvisorDetails = AdvisorDistributionDetails[NewAdvisor];

        if(AdvisorDetails.AdvisorDistrubutionIndex == false)
        {
          AdvisorDetails.AdvisorDistributionAddress = NewAdvisor;
          AdvisorDetails.AdvisorDistributionAmount = Tokenamount;
          AdvisorDetails.AdvisorDistributionAmountLockTime = lockStartTime;
          AdvisorDetails.AdvisorDistributionAmountLockExpiryTime = LockExpiryTime;
          AdvisorDetails.AdvisorpartofTeam = PartofTeam;
          AdvisorDetails.AdvisorDistrubutionIndex = true;
          AdvisorDistributionAddr.push(NewAdvisor);
        }
        else
        {
           require(CheckIfAdvisorActive(NewAdvisor) == true);
                    
            //Add new Token amount and Set new locking Period
            AdvisorDetails.AdvisorDistributionAmount  = AdvisorDetails.AdvisorDistributionAmount.add(Tokenamount);
            AdvisorDetails.AdvisorDistributionAmountLockTime = lockStartTime;
            AdvisorDetails.AdvisorDistributionAmountLockExpiryTime = LockExpiryTime;
        }

 
 }


 //Remove Advisor For Further Investment and from the Team
 function RemoveAdvisorFromFurtherInvestment(address NewAdvisorAddr)  public returns(bool)
 {
    AdvisorDistribution storage newAdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
    require(newAdvisorDetails.AdvisorDistrubutionIndex == true);
    newAdvisorDetails.AdvisorpartofTeam = false;
    return true;



 }

 //Ends

    
   //Token distribution details
  /////////////////////////////////////////
  //Token Distribution Details --- Founder 
 //The distribution amount, Timelock  is fixed   
 //Rewards Token : The Amount of token to be used for Bounty and Rewards
  uint256 public constant InitialRewardsBountyToken = 1000; //To be updated via Script
  uint256 public constant RewardBountylockinPeriod  = 234567;  
  uint256 public RewardsBountyToken;


 //Company Holdings
 address public constant CompanyHoldingAddress = 0xcf530e5b154EB28A379cF5774d5d15B04cF10422;//To be updated via Script
 uint256 public constant InitialCompanyHoldingValue = 1000;// Value to be updated via Script
 uint256 public CompanyHoldingValue;
 uint256 public constant CompanyHoldinglockingPeriod = 123456; //Token LockTIme
 


function ReleaseCompanyHoldingTokens(uint256 currentdatetime)  public returns(uint256)
{
  require(currentdatetime > CompanyHoldinglockingPeriod);
  return CompanyHoldingValue;
    
}

/*
//ReleaseToken to Founder 
   function ReleaseTokenToFounder(address founderAddress, uint256 currentDateTime)  onlyTokenOwner(owner) public returns(uint256)
   {
      FounderDistribution storage FounderDetails = FounderTokenDetails[founderAddress];

      //check if eligible for token
      require(currentDateTime > FounderDetails.LockExpiryTime);
      return FounderDetails.FounderToken;
   }

   */
   
/*
   //ReleaseToken to Advisor
   function ReleaseTokenToAdvisor(address AdvisorAddress, uint256 currentDateTime)  onlyTokenOwner(owner) public returns(uint256)
   {
     AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[AdvisorAddress];
    //check if eligible for token
      require(currentDateTime > AdvisorDetails.AdvisorDistributionAmountLockExpiryTime);
     return AdvisorDetails.AdvisorDistributionAmount;
   }
   

    //ReleaseToken to Team
   function ReleaseTokenToTeam(address TeamAddress, uint256 currentDateTime)  onlyTokenOwner(owner) public returns(uint256)
   {
      TeamDistribution storage TeamDetails = TeamDistributionDetails[TeamAddress];
     //check if eligible for token
      require(currentDateTime > TeamDetails.TeamDistributionAmountLockExpiryDateTime);
      return TeamDetails.TeamDistributionAmount;
   }
*/
 
}