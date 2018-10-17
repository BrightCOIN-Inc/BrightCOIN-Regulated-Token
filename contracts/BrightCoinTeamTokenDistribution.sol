
pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";

contract BrightCoinTeamTokenDistribution  is BrightCoinTokenOwner
{


  mapping(address => uint256)TeamBalances;
constructor() public
{
 
}

//Team Distribution  
 //There might be multiple entry to this
 uint256 internal constant InitialAllocatedTeamToken = 2000;  // Token token allocated for Team distribution
 uint256 public TotalAllocatedTeamToken;
 
 
 struct TeamDistribution {
        address addr;
        uint256 tokenamount;
        uint256 lockexpiry;
        bool   TeamActiveInvestor;  //To Ensure if team is still on
        bool tokenlocked;
    
    }

 mapping(address => TeamDistribution) TeamDistributionDetails;
 address[] public TeamTokenDetailsAddr;
 

 //Team Token Distribution  Starts

//Addng Details to Team Token
 function AddTeam(address NewTeamAddr,uint256 Tokenamount,
 uint256 lockexpirydate,
 bool tokenLocked) onlyTokenOwner  public {
     
  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
    TeamDetails.addr = NewTeamAddr;
    TeamDetails.tokenamount = Tokenamount;
    TeamDetails.lockexpiry = lockexpirydate;
    TeamDetails.TeamActiveInvestor = true;
    TeamDetails.tokenlocked = tokenLocked;
    TeamTokenDetailsAddr.push(NewTeamAddr);

 }

 function UpdateTeamTokenDetails(address teamaddr,
                            uint256 Tokenamount,
                            uint256 LockExpiryDateTime) internal
 {
       //check if Team is Active
       require(CheckIfTeamActive(teamaddr) == true);
      TeamDistribution storage TeamDetails = TeamDistributionDetails[teamaddr];
 
      TeamDetails.tokenamount += Tokenamount;
      TeamDetails.lockexpiry = LockExpiryDateTime;
  
 }

 function RemoveTeamFromFurtherInvestment(address NewTeamAddr) onlyTokenOwner public 
 {
    TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
    TeamDetails.TeamActiveInvestor = false;

 }



 function TotalTeamnvestor() public view returns(uint256) 
 {
   return TeamTokenDetailsAddr.length;
  
 }

//check if Team Removed 
 function CheckIfTeamActive(address TeamAddr) view internal returns(bool)
 {

  TeamDistribution storage TeamDetails = TeamDistributionDetails[TeamAddr];

  if(TeamDetails.TeamActiveInvestor == true)
  {
      return true;
  }
  return false;

 }

 //check Amount with Advisor
 function CheckTeamTokenAmount(address NewTeamAddr) view public returns(uint256)
 {

  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
        return TeamDetails.tokenamount;

 }

}