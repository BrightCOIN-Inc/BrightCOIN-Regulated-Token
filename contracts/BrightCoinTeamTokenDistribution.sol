
pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";

contract BrightCoinTeamTokenDistribution is BrightCoinTokenOwner
{


address owner;
constructor(address _owner) public
{
  owner = _owner;
}
//Team Distribution  
 //There might be multiple entry to this
 uint256 public constant InitialAllocatedTeamToken = 100000;  // Token token allocated for Team distribution
 uint256 public TotalAllocatedTeamToken;
 uint256 internal currentAllocatedTeamToken = 0;  //To be added as it is 
 
 struct TeamDistribution {
        address TeamDistributionAddress;
        uint256 TeamDistributionAmount;
        uint256 TeamDistributionAmountLockStatrDateTime;
        uint256 TeamDistributionAmountLockExpiryDateTime;
        bool    TeamActiveInvestor;  //To Ensure if team is still on
        bool    TeamDistributionIndex; //just to ensure this team once got the investment   
    }

 mapping(address => TeamDistribution) TeamDistributionDetails;
 address[] public TeamTokenDetailsAddr;
 
 //Addng Details to Team Token
 function AddTeamInvestor(address NewTeamAddr,uint256 Tokenamount,uint256 TokenLockStartDateTime,uint256 TokenLockEndDateTime, bool partofTeam) onlyTokenOwner(owner) public {
     
  require(IsTokenAvailable(Tokenamount) == true);

  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
 // require(TeamDetails.partOfTeam == true);

  if(TeamDetails.TeamDistributionIndex == false) //New Team
  {
    TeamDetails.TeamDistributionAddress = NewTeamAddr;
    TeamDetails.TeamDistributionAmount = Tokenamount;
    TeamDetails.TeamDistributionAmountLockStatrDateTime = TokenLockStartDateTime;
    TeamDetails.TeamDistributionAmountLockExpiryDateTime = TokenLockEndDateTime;
    TeamDetails.TeamActiveInvestor = partofTeam;
    TeamDetails.TeamDistributionIndex = true;
    TeamTokenDetailsAddr.push(NewTeamAddr);
  }
  else
  {
      //check if Team is Active
      require(CheckIfTeamActive(NewTeamAddr) == true);
      TeamDetails.TeamDistributionAmount += Tokenamount;
      TeamDetails.TeamDistributionAmountLockStatrDateTime = TokenLockStartDateTime;
      TeamDetails.TeamDistributionAmountLockExpiryDateTime = TokenLockEndDateTime;
  }
  
 }

 function RemoveTeamFromFurtherInvestment(address NewTeamAddr) public 
 {
    TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
    TeamDetails.TeamActiveInvestor = false;

 }
 
 function IsTokenAvailable(uint256 Tokenamount) public returns(bool)
 {
     require(currentAllocatedTeamToken <=TotalAllocatedTeamToken);
     require(currentAllocatedTeamToken + Tokenamount < TotalAllocatedTeamToken);
     currentAllocatedTeamToken += Tokenamount;
     return true;
 }

 function TotalTeamnvestor() public view returns(uint256) 
 {
   return TeamTokenDetailsAddr.length;
  
 }

//check if Team Removed 
 function CheckIfTeamActive(address TeamAddr) view public returns(bool)
 {

  TeamDistribution storage TeamDetails = TeamDistributionDetails[TeamAddr];

  if(TeamDetails.TeamActiveInvestor == true)
  {
      return true;
  }
  return false;

 }

 //check Amount with Advisor
 function CheckTeamTokenAmount(address NewAdvisorAddr) view public returns(uint256)
 {

  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewAdvisorAddr];
  //require(TeamDetails.TeamDistributionIndex == true);
        return TeamDetails.TeamDistributionAmount;

 }



}