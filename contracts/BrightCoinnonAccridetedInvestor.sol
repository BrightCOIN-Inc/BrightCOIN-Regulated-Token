/*
Reg S -
 This is for USA companies raising money outside USA. 
 This can have a 6 Month or a 1 year lockin. 
 (KYC/AML has to be done). The other rule is that these tokens cannot be sold to a USA person for a 1 year period. 
 */

pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract BrightCoinnonAccridetedInvestor is BrightCoinTokenOwner
{


using SafeMath for uint;
constructor() public
{
 
}
  /////////////////////////////////////////////

    struct NonAccredetedInvestor {
        address Investor;
        uint256 InvestorGeoLocation;
        string ipfsHashRegSInvestor; //It must contains the details of Investor
      
    }

    mapping(address => NonAccredetedInvestor) NonAccredetedInvestorDetails;
    address[] public NonAccredetedInvestors;

    /*Function to Add Investor details*/
     function  AddNonAccredetedInvestorDetails(address Investoraddr,uint256 InvestorGeoLocation, string ipfsHashRegSInvestor )onlyTokenOwner public {
      
      require(Investoraddr != 0x0);

       NonAccredetedInvestor storage Investment = NonAccredetedInvestorDetails[Investoraddr];

       Investment.Investor = Investoraddr;
       Investment.InvestorGeoLocation = InvestorGeoLocation;
       Investment.ipfsHashRegSInvestor = ipfsHashRegSInvestor;
       NonAccredetedInvestors.push(Investoraddr);
}

    
 function GetGeoLocationOfInvestor(address Investoraddr) view public returns(uint256)
 {
    NonAccredetedInvestor storage structNonAccredeted =  NonAccredetedInvestorDetails[Investoraddr];
    return structNonAccredeted.InvestorGeoLocation;
 }

/*function SetLockingPeriodRegS(address Investoraddr, uint256 lockExpiryDateTime, uint256 tokenamount) internal {

  require(lockExpiryDateTime > 0);
  require(Investoraddr != 0x0);

  
  NonAccredetedInvestor storage structNonAccredeted =  NonAccredetedInvestorDetails[Investoraddr];
  structNonAccredeted.lockInEndDate =  lockExpiryDateTime;
  structNonAccredeted.InvestedAmount  =  structNonAccredeted.InvestedAmount.add(tokenamount);
  
}
*/

/*
function GetTokenLockExpiryDateTimeRegS(address Investoraddr)  view internal returns(uint256) {

 require(Investoraddr != 0x0);

 NonAccredetedInvestor storage structNonAccredeted =  NonAccredetedInvestorDetails[Investoraddr];
 return structNonAccredeted.lockInEndDate;

 }
 */


}