pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";

contract BrightCoinInvestorKYC is BrightCoinTokenOwner
{



constructor() public
{

}
    
struct BrightCoinInvestorKYCstruct {

    address whitelistedAddress; // Whitelist customer address
    bool KYCStatus;  //KYC Done Status
    uint256 KYCExpiryDateTime; //KYC Expity Date Time
    string ipfsHashKYC; //It must contains the details of Investor
  }

mapping(address => BrightCoinInvestorKYCstruct) BrightCoinInvestorKYCDetails;
address[] public BrightCoinInvestorKYCAddr;

function SetKYCDetailsofInvestor(address InvestordAddress,bool KYCStatus,
                                uint256 KYCExpiryDateTime, string ipfsHashKYC) onlyTokenOwner public 
 {

       BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];
       InvestorKYC.whitelistedAddress = InvestordAddress;
       InvestorKYC.KYCStatus = KYCStatus;
       InvestorKYC.KYCExpiryDateTime = KYCExpiryDateTime;
       InvestorKYC.ipfsHashKYC = ipfsHashKYC;
       BrightCoinInvestorKYCAddr.push(InvestordAddress);
   }

  function SetKYCStatus(address InvestorAddress, bool kycStatus) onlyTokenOwner public 
  {

    require(InvestorAddress != 0x0);

    BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestorAddress];
    InvestorKYC.KYCStatus = kycStatus;

  }
function CheckKYCStatus(address InvestordAddress,uint256 currentDateTime)  public view returns(bool)
{
    require(InvestordAddress != 0x0);
    require(currentDateTime != 0);

    BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];

    return InvestorKYC.KYCStatus;
}



function GetKYCDetails(address InvestordAddress)  public view returns(string)
{ 
    
    BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];
    return InvestorKYC.ipfsHashKYC;
}


function SetKYCExpiryDateTime(address InvestordAddress,uint256 expiryDateTime)  onlyTokenOwner public 
{

     require(InvestordAddress != 0x0);
    require(expiryDateTime != 0);
    BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];
    InvestorKYC.KYCExpiryDateTime = expiryDateTime;

}
function GetKYCExpiryDate(address InvestordAddress)  public view returns(uint256)
{
    
    BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];
    return InvestorKYC.KYCExpiryDateTime;
}



function GetKYCCount() view public returns(uint256)
{
    
    return BrightCoinInvestorKYCAddr.length;
   
}


}