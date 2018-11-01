/*
Reg D - 
For USA citizens only. 
These are for sale to accredited investors only .
There is a 1 year lockin period. 
The only exception is that one accredited investor can sell to another accredited investor.
*/

pragma solidity ^0.4.25;

import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

contract  BrightCoinAccreditionInvestor is BrightCoinTokenOwner
{

using SafeMath for uint;

constructor() public
{
  
}

struct accreditedInvestor
{
    address investor;
    bool    accreditionStatus;
    uint256 accreditionExpiryDateTime;
    uint256 investorGeoLocation;  //Must be USA Citizen Only in Case of RegDRegS Investment
    string ipfsHashRegDInvestor; //It must contains the details of Investor
       
}

     mapping(address => accreditedInvestor) accreditedInvestorDetails;
     address[] public accreditedInvestors;

     /* Function to Add Investor details*/
     function  AddInvestorAccreditionDetails(address _investoraddr,
                                            bool _accreditionStatus,
                                            uint256 _accreditionExpiryDateTime,
                                            uint256 _investorGeoLocation, 
                                            string _ipfsHashRegDInvestor )
                                            public onlyTokenOwner 
      {
      
      require(_investoraddr != 0x0);
      require(_accreditionExpiryDateTime > 0);

       accreditedInvestor storage investment = accreditedInvestorDetails[_investoraddr];

       investment.investor = _investoraddr;
       investment.accreditionStatus = _accreditionStatus;
       investment.accreditionExpiryDateTime = _accreditionExpiryDateTime;
       investment.investorGeoLocation = _investorGeoLocation;
       investment.ipfsHashRegDInvestor = _ipfsHashRegDInvestor;
       accreditedInvestors.push(_investoraddr);
}




 function GetGeoLocationAccreditedInvestor(address _accreditedInvestoraddr )
                                view  public returns(uint256)
 {
      accreditedInvestor storage structAccredited =  accreditedInvestorDetails[_accreditedInvestoraddr];
      require(structAccredited.investorGeoLocation !=0, "Geolocation Should not be zero");
      return structAccredited.investorGeoLocation;
 }

function SetAccreditionStatus(address _investorAddress,
                                    bool _status)
                                    public onlyTokenOwner 
{
    require(_investorAddress != 0);
    accreditedInvestor storage structAccredited =  accreditedInvestorDetails[_investorAddress];
    structAccredited.accreditionStatus = _status;
}

 function CheckAccreditionStatus( address _accreditedInvestoraddr)  view  public 
 returns(bool)
 {
   accreditedInvestor storage structAccredited =  accreditedInvestorDetails[_accreditedInvestoraddr];
   return structAccredited.accreditionStatus;
 
 }

  function SetAccreditionExpiryDateTime(address _accreditedInvestoraddr, uint256 _expiryDateTime)  onlyTokenOwner public
  {
      require(_accreditedInvestoraddr != 0);
      accreditedInvestor storage structAccredited =  accreditedInvestorDetails[_accreditedInvestoraddr];
      structAccredited.accreditionExpiryDateTime = _expiryDateTime;
  }


 }
