pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract BrightCoinAdvisorTokenDistribution  is BrightCoinTokenOwner
{


using SafeMath for uint;
mapping(address => uint256)AdvisorBalances;


constructor() public
{

}
  //There might be multiple entry to this
 uint256 internal constant InitialAllocatedAdvisorToken = 5000;
 uint256 public TotalAllocatedAdvisorToken;
 
 

  // AddAdvisor(ddr,token,expiryDateTime,tokenlocked);
 struct AdvisorDistribution {
        address addr;
        uint256 tokenamount;
        uint256 expiryDateTime;
        bool   AdvisorpartofTeam;
        bool  tokenlocked;
    }
 mapping(address => AdvisorDistribution) AdvisorDistributionDetails;
 address[] public AdvisorDistributionAddr;
 
 
 //Advisor Starts
//Adding New Advisor for Token Distribution
 function AddAdvisor(address NewAdvisor,uint256 Tokenamount,uint256 lockexpiryTime,bool tokenlocked)   internal
  {
    
        AdvisorDistribution storage  AdvisorDetails = AdvisorDistributionDetails[NewAdvisor];

       AdvisorDetails.addr = NewAdvisor;
       AdvisorDetails.tokenamount = Tokenamount;
       AdvisorDetails.expiryDateTime = lockexpiryTime;
       AdvisorDetails.AdvisorpartofTeam = true;
       AdvisorDetails.tokenlocked   = tokenlocked;
    
        AdvisorDistributionAddr.push(NewAdvisor);
 
 }

function UpdateAdvisorTokenDetails (address NewAdvisor,uint256 Tokenamount,
  uint256 LockExpiryDateTime) internal
{
 require(CheckIfAdvisorActive(NewAdvisor) == true);
  AdvisorDistribution storage  AdvisorDetails = AdvisorDistributionDetails[NewAdvisor];
                  
   //Add new Token amount and Set new locking Period
   AdvisorDetails.tokenamount  = AdvisorDetails.tokenamount.add(Tokenamount);
   AdvisorDetails.expiryDateTime = LockExpiryDateTime;

        
}

 //Remove Advisor For Further Investment and from the Team
 function RemoveAdvisorFromFurtherInvestment(address NewAdvisorAddr) onlyTokenOwner public returns(bool)
 {
    AdvisorDistribution storage newAdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
    newAdvisorDetails.AdvisorpartofTeam = false;
    return true;
 }

 //Ends


 //check if Advisor Removed 
 function CheckIfAdvisorActive(address NewAdvisorAddr) view internal returns(bool)
 {

  AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
  if(AdvisorDetails.AdvisorpartofTeam == true)
  {
      return true;
  }
  return false;

 }

//Count total no of Advisors
 function TotalAdvisor() onlyTokenOwner public view returns(uint256) 
 {
   return AdvisorDistributionAddr.length;
 }


 //check Amount with Advisor
 function CheckAdvisorTokenAmount(address NewAdvisorAddr) onlyTokenOwner public view returns(uint256)
 {

  AdvisorDistribution storage AdvisorDetails = AdvisorDistributionDetails[NewAdvisorAddr];
  return AdvisorDetails.tokenamount ;

 }

 }
