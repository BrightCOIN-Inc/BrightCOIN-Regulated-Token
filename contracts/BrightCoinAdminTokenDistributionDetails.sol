
pragma solidity ^0.4.24;

import "./BrightCoinTeamTokenDistribution.sol"; 
import "./BrightCoinFounderTokenDistribution.sol"; 
import "./BrightCoinAdvisorTokenDistribution.sol"; 
import "./SafeMath.sol";
import "./BrightCoinTokenOwner.sol";
import "./BrightCoinTokenConfig.sol";

contract BrightCoinAdminTokenDistributionDetails is BrightCoinAdvisorTokenDistribution,
BrightCoinTeamTokenDistribution,
BrightCoinFounderTokenDistribution,
BrightCoinTokenConfig
{

using SafeMath for uint;


  mapping(address => uint256)CompanyHoldingBalances;
  mapping(address => uint256)BountyBalances;

enum BrightCoinAdminType { Founder, Advisor, Team }

constructor() public
{
 
}


  //Token distribution details
  /////////////////////////////////////////
  //Token Distribution Details --- Founder 
uint256 public TotalAllocatedFounder = 0;
uint256 public CurrentAllocatedFounderToken = 0; //To be taken as it is 
uint256 public CompanyHoldingValue = 0;
uint256 public BountyAllocated = 0;

  modifier onlyBountyTokenOwner() {
        require(msg.sender == BountyTokenHolder, " Bounty Owner Not Authorized");
        _;
    }
  

 function AddAdminToken(address _addr, uint256 _expiryDateTime, 
                                      uint256 _token, bool _tokenlocked, uint8 _adminType) internal
 {


  if(_adminType == uint8(BrightCoinAdminType.Founder))
    {
       AddFounder(_addr,_token,_expiryDateTime,_tokenlocked);
    }
    else if (_adminType == uint8(BrightCoinAdminType.Advisor))
    {
     AddAdvisor(_addr,_token,_expiryDateTime,_tokenlocked);
    }
    else if(_adminType == uint8(BrightCoinAdminType.Team))
    {
      AddTeam(_addr,_token,_expiryDateTime,_tokenlocked);

    }
    

 }


function UpdateAdminTokenDetails(address _addr, uint256 _expiryDateTime, 
                                      uint256 _tokens, uint8 _adminType) internal
 {

  if(_adminType == uint8(BrightCoinAdminType.Founder))
    {
      UpdateFounderTokenDetails(_addr,_tokens,_expiryDateTime);
    }
    else if (_adminType == uint8(BrightCoinAdminType.Advisor))
    {
        UpdateAdvisorTokenDetails(_addr,_tokens,_expiryDateTime);
    }
    else if(_adminType == uint8(BrightCoinAdminType.Team))
    {
        UpdateTeamTokenDetails(_addr,_tokens,_expiryDateTime);

    }  

 }

 

 
}