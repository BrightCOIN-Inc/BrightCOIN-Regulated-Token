
pragma solidity ^0.4.24;

import "./BrightCoinTeamTokenDistribution.sol"; 
import "./BrightCoinFounderTokenDistribution.sol"; 
import "./BrightCoinAdvisorTokenDistribution.sol"; 
import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";

contract BrightCoinAdminTokenDistributionDetails is BrightCoinAdvisorTokenDistribution,BrightCoinTeamTokenDistribution,BrightCoinFounderTokenDistribution
{

using SafeMath for uint;


  mapping(address => uint256)CompanyHoldingBalances;
  mapping(address => uint256)BountyBalances;

enum BrightCoinAdminType { Founder, Advisor, Team, CompanyHolding, Bounty }

constructor() public
{
 
}


  //Token distribution details
  /////////////////////////////////////////
  //Token Distribution Details --- Founder 
uint256 public constant InitialFounderToken = 20000;
uint256 public TotalAllocatedFounder = 0;
uint256 public CurrentAllocatedFounderToken = 0; //To be taken as it is 


 //Company Holdings
 address public constant CompanyHoldingAddress = 0xfedf9e65af88f215738e74114cb2c2218076f8b5;
 uint256 public constant InitialCompanyHoldingValue = 40000;// Value to be updated via Script
 uint256 public CompanyHoldingValue = 0;



//Bounty Token Distribution
uint256 public constant totalBountyAllocated = 3000;
uint256 public BountyAllocated = 0;
address public  constant BountyTokenHolder = 0x30533279DeF53608a38e9147E7B648d16A0A84Fb; //This address own the token and finally transfer
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

 

 
}