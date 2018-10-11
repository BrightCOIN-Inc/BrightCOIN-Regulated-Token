
pragma solidity ^0.4.24;

import "./BrightCoinTeamTokenDistribution.sol"; 
import "./BrightCoinFounderTokenDistribution.sol"; 
import "./BrightCoinAdvisorTokenDistribution.sol"; 
import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";

contract BrightCoinAdminTokenDistributionDetails is BrightCoinAdvisorTokenDistribution,BrightCoinTeamTokenDistribution,BrightCoinFounderTokenDistribution
{

using SafeMath for uint;

enum BrightCoinAdminType { Founder, Advisor, Team }

constructor() public
{
 
}


  //Token distribution details
  /////////////////////////////////////////
  //Token Distribution Details --- Founder 

 //Company Holdings
 address public constant CompanyHoldingAddress = 0xfedf9e65af88f215738e74114cb2c2218076;//To be updated via Script
 uint256 public constant InitialCompanyHoldingValue = 40000;// Value to be updated via Script
 uint256 public CompanyHoldingValue = 0;



//Bounty Token Distribution
uint256 public constant totalBountyAllocated = 3000;
uint256 public BountyAllocated = 0;
address public  constant BountyTokenHolder = 0x826bbe56a1a5b3b83346530a6d1791b1bc8b0c5e; //This address own the token and finally transfer
  modifier onlyBountyTokenOwner() {
        require(msg.sender == BountyTokenHolder, " Bounty Owner Not Authorized");
        _;
    }
  

 function AddAdminToken(address addr, uint256 expiryDateTime, 
                                      uint256 token, bool tokenlocked, uint8 AdminType) internal
 {


  if(AdminType == uint8(BrightCoinAdminType.Founder))
    {
       AddFounder(addr,token,expiryDateTime,tokenlocked);
    }
    else if (AdminType == uint8(BrightCoinAdminType.Advisor))
    {
     AddAdvisor(addr,token,expiryDateTime,tokenlocked);
    }
    else if(AdminType == uint8(BrightCoinAdminType.Team))
    {
      AddTeam(addr,token,expiryDateTime,tokenlocked);

    }
    

 }


function UpdateAdminTokenDetails(address addr, uint256 expiryDateTime, 
                                      uint256 tokens, uint8 AdminType) internal
 {

  if(AdminType == uint8(BrightCoinAdminType.Founder))
    {
      UpdateFounderTokenDetails(addr,tokens,expiryDateTime);
    }
    else if (AdminType == uint8(BrightCoinAdminType.Advisor))
    {
        UpdateAdvisorTokenDetails(addr,tokens,expiryDateTime);
    }
    else if(AdminType == uint8(BrightCoinAdminType.Team))
    {
        UpdateTeamTokenDetails(addr,tokens,expiryDateTime);

    }  

 }

 //Check if token is available for further Distribution to Admin
 function TokenAvailableForAdmin(address addr,
                     uint256 currentBalance,
                     uint256 TokenAmount,
                     uint8 AdminType )  internal  returns(bool)
 {
     if(AdminType == uint8(BrightCoinAdminType.Founder))
    {
      require(currentBalance <=TotalAllocatedFounder);
      require(currentBalance.add(TokenAmount) <= TotalAllocatedFounder);
      return true;
    }
    else if (AdminType == uint8(BrightCoinAdminType.Advisor))
    {
      require(currentBalance <= TotalAllocatedAdvisorToken);
      require(currentBalance.add(TokenAmount) <= TotalAllocatedAdvisorToken);
      return true;
    }
    else if(AdminType == uint8(BrightCoinAdminType.Team))
    {
      require(currentBalance <=TotalAllocatedTeamToken);
      require(currentBalance.add(TokenAmount) <= TotalAllocatedTeamToken);
      return true;

    }  
 }

//Check if token is available for further Distribution to Advisor
 function TokenAvailableForBounty(uint256 TokenBalance, uint256 Tokenamount) internal returns(bool)
 {
     require(TokenBalance <= BountyAllocated);
     require(TokenBalance.add(Tokenamount) <= BountyAllocated);
     return true;
 }  

 
 
}