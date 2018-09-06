/*
Reg S -
 This is for USA companies raising money outside USA. 
 This can have a 6 Month or a 1 year lockin. 
 (KYC/AML has to be done). The other rule is that these tokens cannot be sold to a USA person for a 1 year period. 
 */

pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract BrightCoinRegSInvestor is BrightCoinTokenOwner
{


address owner;
using SafeMath for uint;
constructor(address _owner) public
{
  owner = _owner;
}
  /////////////////////////////////////////////

    struct RegSInvestor {
        address Investor;
        uint256 lockInEndDate;
        uint256 InvestedAmount;
        uint256 InvestorGeoLocation;
        string ipfsHashRegSInvestor; //It must contains the details of Investor
      
    }

    mapping(address => RegSInvestor) RegSInvestorsDetails;
    address[] public regSInvestors;

    /*Function to Add Investor details*/
     function  AddRegSInvestorDetails(address Investoraddr,uint256 InvestorGeoLocation, string ipfsHashRegSInvestor )
                                          onlyTokenOwner(owner) public {
      
      require(Investoraddr != 0x0);

       RegSInvestor storage Investment = RegSInvestorsDetails[Investoraddr];

       Investment.Investor = Investoraddr;
       Investment.InvestorGeoLocation = InvestorGeoLocation;
       Investment.ipfsHashRegSInvestor = ipfsHashRegSInvestor;
       Investment.lockInEndDate = 0;
       Investment.InvestedAmount = 0;
       regSInvestors.push(Investoraddr);
}

    
 function GetGeoLocationOfInvestor(address Investoraddr) view public returns(uint256)
 {
    RegSInvestor storage structRegS =  RegSInvestorsDetails[Investoraddr];
    return structRegS.InvestorGeoLocation;
 }

function SetLockingPeriodRegS(address RegSInvestoraddr, uint256 lockExpiryDateTime, uint256 tokenamount) internal {

  require(lockExpiryDateTime > 0);
  require(RegSInvestoraddr != 0x0);

  
  RegSInvestor storage structRegS =  RegSInvestorsDetails[RegSInvestoraddr];
  structRegS.lockInEndDate =  lockExpiryDateTime;
  structRegS.InvestedAmount  =  structRegS.InvestedAmount.add(tokenamount);
  
}


function GetTokenLockExpiryDateTimeRegS(address RegSInvestoraddr)  view internal returns(uint256) {

 require(RegSInvestoraddr != 0x0);

 RegSInvestor storage structRegS =  RegSInvestorsDetails[RegSInvestoraddr];
 return structRegS.lockInEndDate;

 }


}