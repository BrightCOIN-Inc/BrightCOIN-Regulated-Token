/*
Reg D - 
For USA citizens only. 
These are for sale to accredited investors only .
There is a 1 year lockin period. 
The only exception is that one accredited investor can sell to another accredited investor.
*/

pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract  BrightCoinRegDInvestor is BrightCoinTokenOwner
{

using SafeMath for uint;
uint256 public  TotalInvestmentCurrently;
uint256 public constant USAGeoLocation = 1;

address owner;
constructor(address _owner) public
{
  owner = _owner;
}

struct RegDInvestor
{
    address Investor;
    bool    AccreditionStatus;
    uint256 AccreditionExpiryDateTime;
    uint256 lockInEndDate;
    uint256 TokenPurchased;
    uint256 InvestorGeoLocation;  //Must be USA Citizen Only in Case of RegDRegS Investment
    string ipfsHashRegDInvestor; //It must contains the details of Investor
       
}

     mapping(address => RegDInvestor) RegDInvestorsDetails;
     address[] public regDInvestors;

     /* Function to Add Investor details*/
     function  AddRegDInvestorDetails(address Investoraddr,bool AccreditionStatus,uint256 AccreditionExpiryDateTime,uint256 InvestorGeoLocation, string ipfsHashRegDInvestor )
      onlyTokenOwner(owner) public {
      
      require(Investoraddr != 0x0);
      require(AccreditionExpiryDateTime > 0);

       RegDInvestor storage Investment = RegDInvestorsDetails[Investoraddr];

       Investment.Investor = Investoraddr;
       Investment.AccreditionStatus = AccreditionStatus;
       Investment.AccreditionExpiryDateTime = AccreditionExpiryDateTime;
       Investment.InvestorGeoLocation = InvestorGeoLocation;
       Investment.ipfsHashRegDInvestor = ipfsHashRegDInvestor;
       Investment.lockInEndDate = 0;
       Investment.TokenPurchased = 0;

       regDInvestors.push(Investoraddr);
}




 function CheckGeoLocationRegD(address RegDInvestoraddr ) view internal returns(uint256)
 {
      RegDInvestor storage structRegD =  RegDInvestorsDetails[RegDInvestoraddr];
      return structRegD.InvestorGeoLocation;
 }



 function CheckAccreditionStatusRegD( address RegDInvestoraddr, uint256 currentdatetime)  view internal returns(bool)
 {

    if((currentdatetime > 0) && (RegDInvestoraddr != 0x0))
      {

        RegDInvestor storage structRegD =  RegDInvestorsDetails[RegDInvestoraddr];
        if((structRegD.AccreditionExpiryDateTime > currentdatetime) && (structRegD.AccreditionStatus == true))
             return true;
      }

      return false;
   
 }

 function SetLockingPeriodRegD(address RegDInvestoraddr, uint256 expiryDateTime, uint256 tokenamount)  internal {

  require(expiryDateTime > 0);
  require(RegDInvestoraddr != 0x0);

  RegDInvestor storage structRegD =  RegDInvestorsDetails[RegDInvestoraddr];

  structRegD.lockInEndDate =  expiryDateTime;
  structRegD.TokenPurchased  = structRegD.TokenPurchased.add(tokenamount);
  

 }

 function GetTokenLockExpiryDateTimeRegD(address RegDInvestoraddr) view  internal  returns(uint256) {

 if(RegDInvestoraddr != 0x0)
 {
    RegDInvestor storage structRegD =  RegDInvestorsDetails[RegDInvestoraddr];
    return structRegD.lockInEndDate;
 }
 return 0;
 
 }


 }
