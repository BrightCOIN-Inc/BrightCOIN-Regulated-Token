
pragma solidity ^0.4.24;


contract BrightCoinTeamTokenDistribution 
{


constructor() public
{
 
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
 function CheckTeamTokenAmount(address NewTeamAddr) view public returns(uint256)
 {

  TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];
  //require(TeamDetails.TeamDistributionIndex == true);
        return TeamDetails.TeamDistributionAmount;

 }

/*function GetTeamToken(address NewTeamAddr, uint256 currentdatetime)   internal  returns(uint256)
{

TeamDistribution storage TeamDetails = TeamDistributionDetails[NewTeamAddr];

  //check if eligible for token
  require(currentdatetime > TeamDetails.TeamDistributionAmountLockExpiryDateTime);

   return TeamDetails.TeamDistributionAmount;
}
*/



}