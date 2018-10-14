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

    struct NonAccreditedInvestor {
        address Investor;
        uint256 InvestorGeoLocation;
        string ipfsHashRegSInvestor; //It must contains the details of Investor
      
    }

    mapping(address => NonAccreditedInvestor) NonAccreditedInvestorDetails;
    address[] public NonAccreditedInvestors;

    /*Function to Add Investor details*/
     function  AddNonAccreditedInvestorDetails(address Investoraddr,
                             uint256 InvestorGeoLocation,
                           string ipfsHashRegSInvestor )
                           onlyTokenOwner public
    {
      
      require(Investoraddr != 0x0);
       NonAccreditedInvestor storage Investment = NonAccreditedInvestorDetails[Investoraddr];
       Investment.Investor = Investoraddr;
       Investment.InvestorGeoLocation = InvestorGeoLocation;
       Investment.ipfsHashRegSInvestor = ipfsHashRegSInvestor;
       NonAccreditedInvestors.push(Investoraddr);
    }

    
 function GetGeoLocationOfNonInvestor(address Investoraddr) 
                view  public returns(uint256)
 {
    NonAccreditedInvestor storage structNonAccredeted =  NonAccreditedInvestorDetails[Investoraddr];
    require(structNonAccredeted.InvestorGeoLocation !=0, "Geolocation Should not be zero");
    return structNonAccredeted.InvestorGeoLocation;
 }


}