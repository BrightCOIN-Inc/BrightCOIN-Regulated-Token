pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";

contract BrightCoinFounderTokenDistribution  is BrightCoinTokenOwner
{


using SafeMath for uint;

//There might be multiple entry to this
uint256 public constant InitialFounderToken = 100000;
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

//Add Founder Starts

function AddNewFounder(address newFounder,uint256 FounderToken,uint256 LockExpiryDateTime, bool FounderPartofTeam)    onlyTokenOwner   public 
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

//Remove Founder For Further Investment and from the Team
 function RemoveFounderFromFurtherInvestment(address NewFounderAddr)  onlyTokenOwner public returns(bool)
 {
   FounderDistribution storage newFounderDetails = FounderTokenDetails[NewFounderAddr];
   require(newFounderDetails.FounderIndex == true);
   newFounderDetails.FounderActive = false;
    
    return true;

 }

//ENDS

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


 
