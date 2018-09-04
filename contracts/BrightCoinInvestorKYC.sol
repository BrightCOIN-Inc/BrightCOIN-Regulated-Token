pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";

contract BrightCoinInvestorKYC is BrightCoinTokenOwner
{

uint256 public constant Maximumcontributors = 100000; //Maximum no of Contributors

address owner;
constructor() public
{
  owner = msg.sender;
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
                                uint256 KYCExpiryDateTime, string ipfsHashKYC) onlyTokenOwner(owner) public 
 {
         
      require( BrightCoinInvestorKYCAddr.length <= Maximumcontributors);

       BrightCoinInvestorKYCstruct storage InvestorKYC = BrightCoinInvestorKYCDetails[InvestordAddress];
       InvestorKYC.whitelistedAddress = InvestordAddress;
       InvestorKYC.KYCStatus = KYCStatus;
       InvestorKYC.KYCExpiryDateTime = KYCExpiryDateTime;
       InvestorKYC.ipfsHashKYC = ipfsHashKYC;
 
       BrightCoinInvestorKYCAddr.push(InvestordAddress);
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