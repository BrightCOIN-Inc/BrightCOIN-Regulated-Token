pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";

contract BrightCoinFounderTokenDistribution  is BrightCoinTokenOwner
{


using SafeMath for uint;

//There might be multiple entry to this
uint256 public constant InitialFounderToken = 20000;
uint256 public TotalAllocatedFounder = 0;
uint256 public CurrentAllocatedFounderToken = 0; //To be taken as it is 


 struct FounderDistribution {
       address FounderAddress;
       uint256 FounderToken;
       uint256 LockExpiryTime;
       bool    FounderActive;
       bool    Tokenlocked;
    }
    
 mapping(address => FounderDistribution) FounderTokenDetails;
 address[] internal FounderAddrs;

constructor() public
{
 
}

//Add Founder Starts

function AddFounder(address newFounder,uint256 FounderToken,uint256 LockExpiryDateTime,
 bool tokenLocked)   internal 
  {

      //require(TokenAvailableForFounder(FounderToken) == true);
      FounderDistribution storage  FounderDetails = FounderTokenDetails[newFounder];
    
      FounderDetails.FounderAddress = newFounder;
      FounderDetails.FounderToken = FounderToken;
      FounderDetails.LockExpiryTime = LockExpiryDateTime;
      FounderDetails.Tokenlocked = tokenLocked;
      FounderAddrs.push(newFounder);
    
 }


  function  UpdateFounderTokenDetails(address newFounder,uint256 FounderToken,
  uint256 LockExpiryDateTime) internal
  {
    require(CheckIfFounderActive(newFounder) == true);   
   // require(TokenAvailableForFounder(FounderToken) == true);             
     //Add new Token amount and Set new locking Period
      FounderDistribution storage  FounderDetails = FounderTokenDetails[newFounder];
     FounderDetails.FounderToken  = FounderDetails.FounderToken.add(FounderToken);
     FounderDetails.LockExpiryTime = LockExpiryDateTime;     
  }

//Remove Founder For Further Investment and from the Team
 function RemoveFounderFromFurtherInvestment(address NewFounderAddr)  onlyTokenOwner public returns(bool)
 {
   FounderDistribution storage newFounderDetails = FounderTokenDetails[NewFounderAddr];
   newFounderDetails.FounderActive = false;
    
    return true;

 }

//ENDS

//check if Founder Removed 
 function CheckIfFounderActive(address NewFounderAddr) view internal returns(bool)
 {

  FounderDistribution storage founderDetails = FounderTokenDetails[NewFounderAddr];
 if(founderDetails.FounderActive == true)
  {
      return true;
  }
  
  return false;

 }



//Count total no of Advisors
 function TotalFounder() public view returns(uint256) 
 {
   return FounderAddrs.length;
  
 }


 //check Amount with Advisor
 function CheckFounderTokenAmount(address NewFounderAddr) view public returns(uint256)
 {

  FounderDistribution storage FounderDetails = FounderTokenDetails[NewFounderAddr];
  return FounderDetails.FounderToken;
   
 }

}


 
