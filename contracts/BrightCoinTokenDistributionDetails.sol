
pragma solidity ^0.4.24;

import "./BrightCoinTeamTokenDistribution.sol";
import "./BrightCoinAdvisorTokenDistribution.sol";
import "./BrightCoinFounderTokenDistribution.sol";
import "./SafeMath.sol";

contract BrightCoinTokenDistributionDetails is BrightCoinTeamTokenDistribution(msg.sender) ,BrightCoinAdvisorTokenDistribution(msg.sender), BrightCoinFounderTokenDistribution(msg.sender)
{

using SafeMath for uint;
address owner;
constructor(address _owner) public
{
  owner = _owner;
}

    
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
 


function ReleaseCompanyHoldingTokens(uint256 currentdatetime) onlyTokenOwner(owner) view public returns(uint256)
{
  require(currentdatetime > CompanyHoldinglockingPeriod);
  return CompanyHoldingValue;
    
}


 
}