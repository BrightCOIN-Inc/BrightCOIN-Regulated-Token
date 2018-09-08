pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract BrightCoinFounderTokenDistribution  
{


using SafeMath for uint;

//There might be multiple entry to this
uint256 public constant FounderToken = 100000;
uint256 public TotalAllocatedFounder = 0;
uint256 public CurrentAllocatedFounderToken = 0; //To be taken as it is 


 struct FounderDistribution {
       address FounderAddress;
       uint256 FounderToken;
       uint256 LockExpiryTime;
       bool    FounderIndex;
       bool    FounderActive;
    }
    
 mapping(address => FounderDistribution) FounderTokenDetails;
 address[] internal FounderAddrs;

constructor() public
{
 
}


//check if Founder Removed 
 function CheckIfFounderActive(address NewFounderAddr)  internal returns(bool)
 {

  FounderDistribution storage founderDetails = FounderTokenDetails[NewFounderAddr];
 if(founderDetails.FounderActive == true)
  {
      return true;
  }
  
  return false;

 }


 //Check if token is available for further Distribution to Founder
 function TokenAvailableForFounder(uint256 TokenamountFounder)  internal  returns(bool)
 {
    require(CurrentAllocatedFounderToken <=TotalAllocatedFounder);
    require(CurrentAllocatedFounderToken.add(TokenamountFounder) <= TotalAllocatedFounder);
     CurrentAllocatedFounderToken  =  CurrentAllocatedFounderToken.add(TokenamountFounder);

     
     return true;
 }



//Remove Founder For Further Investment and from the Team
 function RemoveFounderFromFurtherInvestment(address NewFounderAddr)  public returns(bool)
 {
   FounderDistribution storage newFounderDetails = FounderTokenDetails[NewFounderAddr];
   require(newFounderDetails.FounderIndex == true);
   newFounderDetails.FounderActive = false;
    
    return true;

 }
 
 

//Count total no of Advisors
 function TotalFounder() public view returns(uint256) 
 {
   return FounderAddrs.length;
  
 }


 //check Amount with Advisor
 function CheckFounderTokenAmount(address NewFounderAddr)  public returns(uint256)
 {

  FounderDistribution storage FounderDetails = FounderTokenDetails[NewFounderAddr];
  require(FounderDetails.FounderIndex == true);
       return FounderDetails.FounderToken;
        
        return 0;
 }


 /*function GetFounderToken(address NewFounderAddr, uint256 currentdatetime)   internal  returns(uint256)
{
FounderDistribution storage FounderDetails = FounderTokenDetails[NewFounderAddr];

  //check if eligible for token
 require(currentdatetime > FounderDetails.LockExpiryTime);

   return FounderDetails.FounderToken;
  
}
*/



}


 
