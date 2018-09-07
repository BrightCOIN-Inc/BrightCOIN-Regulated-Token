pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract BrightCoinFounderTokenDistribution  is BrightCoinTokenOwner
{

address owner;
using SafeMath for uint;

constructor(address _owner) public
{
  owner = _owner;
}


   //There might be multiple entry to this
 uint256 public constant InitialAllocatedFounderToken = 100000;
 uint256 public TotalAllocatedFounderToken;
 uint256 public currentAllocatedFounderToken = 0; //To be taken as it is 
 
 struct FounderDistribution {
        address FounderAddress;
        uint256 FounderToken;
        uint256 LockExpiryDateTime;
        bool    FounderDistrubutionIndex;
        bool    FunderPartofTeam;
    }
 mapping(address => FounderDistribution) FounderDistributionDetails;
 address[] public FounderDistributionAddr;
 
/*

 //Adding New Founder for Token Distribution
 function AddNewFounder(address NewFounder,uint256 Tokenamount,
                    uint256 LockExpiryTime, bool PartofTeam)  onlyTokenOwner(owner)  public
  {

  	
  		require(TokenAvailableForFounder(Tokenamount) == true);

        FounderDistribution storage  FounderDetails = FounderDistributionDetails[NewFounder];

        if(FounderDetails.FounderDistrubutionIndex == false)
        {
   		  FounderDetails.LockExpiryDateTime = LockExpiryTime;
          FounderDetails.FunderPartofTeam = PartofTeam;
          FounderDetails.FounderDistrubutionIndex = true;
          FounderDistributionAddr.push(NewFounder);
        }
        else
        {
           require(CheckIfFounderActive(NewFounder) == true);
                    
            //Add new Token amount and Set new locking Period
            FounderDetails.FounderToken  = FounderDetails.FounderToken.add(Tokenamount);
            FounderDetails.LockExpiryDateTime = LockExpiryTime;
        }
 
 }


//check if Founder Removed 
 function CheckIfFounderActive(address NewFounderAddr) view internal returns(bool)
 {

   FounderDistribution storage founderDetails = FounderDistributionDetails[NewFounderAddr];
  if(founderDetails.FunderPartofTeam == true)
  {
      return true;
  }
  
  return false;

 }


 //Check if token is available for further Distribution to Advisor
 function TokenAvailableForFounder(uint256 Tokenamount) internal returns(bool)
 {
    require(currentAllocatedFounderToken <=TotalAllocatedFounderToken);
     require(currentAllocatedFounderToken.add(Tokenamount) <= TotalAllocatedFounderToken);
     currentAllocatedFounderToken  =  currentAllocatedFounderToken.add(Tokenamount);
     
     return true;
 }


//Remove Founder For Further Investment and from the Team
 function RemoveFounderFromFurtherInvestment(address NewFounderAddr)  public returns(bool)
 {
    FounderDistribution storage newFounderDetails = FounderDistributionDetails[NewFounderAddr];
    require(newFounderDetails.FounderDistrubutionIndex == true);
    newFounderDetails.FunderPartofTeam = false;
    return true;

 }
 

//Count total no of Advisors
 function TotalFounder() public view returns(uint256) 
 {
   return FounderDistributionAddr.length;
 }


 //check Amount with Advisor
 function CheckFounderTokenAmount(address NewFounderAddr) view public returns(uint256)
 {

  FounderDistribution storage FounderDetails = FounderDistributionDetails[NewFounderAddr];
  require(FounderDetails.FounderDistrubutionIndex == true);
        return FounderDetails.FounderToken;
 }


 function GetFounderToken(address NewFounderAddr, uint256 currentdatetime)  view internal  returns(uint256)
{

FounderDistribution storage FounderDetails = FounderDistributionDetails[NewFounderAddr];

  //check if eligible for token
  require(currentdatetime > FounderDetails.LockExpiryDateTime);

   return FounderDetails.FounderToken;
}

*/

 }
