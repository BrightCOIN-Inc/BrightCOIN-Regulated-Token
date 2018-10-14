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

contract  BrightCoinAccreditionInvestor is BrightCoinTokenOwner
{

using SafeMath for uint;
uint256 public  TotalInvestmentCurrently; 
uint256 public constant USAGeoLocation = 1;


constructor() public
{
  
}

struct AccreditedInvestor
{
    address Investor;
    bool    AccreditionStatus;
    uint256 AccreditionExpiryDateTime;
    uint256 InvestorGeoLocation;  //Must be USA Citizen Only in Case of RegDRegS Investment
    string ipfsHashRegDInvestor; //It must contains the details of Investor
       
}

     mapping(address => AccreditedInvestor) AccreditedInvestorDetails;
     address[] public accreditedInvestors;

     /* Function to Add Investor details*/
     function  AddInvestorAccreditionDetails(address Investoraddr,
                                            bool AccreditionStatus,
                                            uint256 AccreditionExpiryDateTime,
                                            uint256 InvestorGeoLocation, 
                                            string ipfsHashRegDInvestor )
                                            onlyTokenOwner public
      {
      
      require(Investoraddr != 0x0);
      require(AccreditionExpiryDateTime > 0);

       AccreditedInvestor storage Investment = AccreditedInvestorDetails[Investoraddr];

       Investment.Investor = Investoraddr;
       Investment.AccreditionStatus = AccreditionStatus;
       Investment.AccreditionExpiryDateTime = AccreditionExpiryDateTime;
       Investment.InvestorGeoLocation = InvestorGeoLocation;
       Investment.ipfsHashRegDInvestor = ipfsHashRegDInvestor;

       accreditedInvestors.push(Investoraddr);
}




 function GetGeoLocationAccreditedInvestor(address AccreditedInvestoraddr )
                                view  public returns(uint256)
 {
      AccreditedInvestor storage structAccredited =  AccreditedInvestorDetails[AccreditedInvestoraddr];
      require(structAccredited.InvestorGeoLocation !=0, "Geolocation Should not be zero");
      return structAccredited.InvestorGeoLocation;
 }

function SetAccreditionStatus(address investorAddress,
                                    bool status)
                                    onlyTokenOwner public
{
    require(investorAddress != 0);
    AccreditedInvestor storage structAccredited =  AccreditedInvestorDetails[investorAddress];
    structAccredited.AccreditionStatus = status;
}

 function CheckAccreditionStatus( address AccreditedInvestoraddr)  view  public 
 returns(bool)
 {
   AccreditedInvestor storage structAccredited =  AccreditedInvestorDetails[AccreditedInvestoraddr];
   return structAccredited.AccreditionStatus;
 
 }

  function SetAccreditionExpiryDateTime(address AccreditedInvestoraddr, uint256 expiryDateTime)  onlyTokenOwner public
  {
      require(AccreditedInvestoraddr != 0);
      AccreditedInvestor storage structAccredited =  AccreditedInvestorDetails[AccreditedInvestoraddr];
      structAccredited.AccreditionExpiryDateTime = expiryDateTime;
  }


 }
