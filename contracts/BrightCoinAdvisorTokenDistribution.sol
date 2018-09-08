pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract BrightCoinAdvisorTokenDistribution 
{


using SafeMath for uint;

constructor() public
{

}
  //There might be multiple entry to this
 uint256 public constant InitialAllocatedAdvisorToken = 100000;
 uint256 public TotalAllocatedAdvisorToken;
 uint256 public currentAllocatedAdvisorToken = 0; //To be taken as it is 
 
 struct AdvisorDistribution {
        address AdvisorDistributionAddress;
        uint256 AdvisorDistributionAmount;
        uint256 AdvisorDistributionAmountLockTime;
        uint256 AdvisorDistributionAmountLockExpiryTime;
        bool  AdvisorDistrubutionIndex;
        bool   AdvisorpartofTeam;
    }
 mapping(address => AdvisorDistribution) AdvisorDistributionDetails;
 address[] public AdvisorDistributionAddr;
 
 
 
 //Check if token is available for further Distribution to Advisor
 function TokenAvailableForAdvisor(uint256 Tokenamount) internal returns(bool)
 {
     require(currentAllocatedAdvisorToken <=TotalAllocatedAdvisorToken);
     require(currentAllocatedAdvisorToken.add(Tokenamount) <= TotalAllocatedAdvisorToken);
     currentAllocatedAdvisorToken  =  currentAllocatedAdvisorToken.add(Tokenamount);
     return true;
 }

 //check if Advisor Removed 
 function CheckIfAdvisorActive(address NewAdvisorAddr) internal returns(bool)
 {

  AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
  if(AdvisorDetails.AdvisorpartofTeam == true)
  {
      return true;
  }
  return false;

 }

//Count total no of Advisors
 function TotalAdvisor() public view returns(uint256) 
 {
   return AdvisorDistributionAddr.length;
 }


 //check Amount with Advisor
 function CheckAdvisorTokenAmount(address NewAdvisorAddr) view public returns(uint256)
 {

  AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
  require(AdvisorDetails.AdvisorDistrubutionIndex == true);
        return AdvisorDetails.AdvisorDistributionAmount;

 }

/*
function GetAdvisorToken(address NewAdvisorAddr, uint256 currentdatetime)   internal  returns(uint256)
{

AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];

  //check if eligible for token
  require(currentdatetime > AdvisorDetails.AdvisorDistributionAmountLockExpiryTime);

   return AdvisorDetails.AdvisorDistributionAmount;
}
*/



 }
