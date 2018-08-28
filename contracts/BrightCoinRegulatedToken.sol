
pragma solidity ^0.4.24;
//pragma experimental "v0.5.0";

import "./BrightCoinInvestorKYC.sol";
import "./BrightCoinTokenOwner.sol";
import "./BrightCoinERC20Contract.sol";
import  "./BrightCoinInvestorAccreditationCheck.sol";

//Rules for Accredited Investors
/*
 This is special BrightCoinToken that will allow User to invest to Token Only after Proper Checks and Validation as provide by US Regulatories Authorities
*/

/*
 import all specific contract that will help in Validation 

 multiSign
 Accridetion
 KYC
 TokenDistribution Details

*/

contract BrightCoinRegulatedToken  is BrightCoinERC20 

{

BrightCoinInvestorKYC InvestorKYCInfo;
BrightCoinInvestorAccreditationCheck AccreditationInfo;
address public BrightCoinInvestorKYCAddress; 
address public BrightCoinInvestorAccreditationAddress; 
mapping(address => uint256) InvestorBalances;
mapping(address => bool) CalculatetokenWithMailSalePeriod;

constructor() public {

   
	
}

function GetCurrentTime() view public returns(uint256)
{
    return now;
}

//Calculate Token Amount to be Provided.   
function calculateTokenmount()  private {
  

   require(InvestorKYCInfo.CheckKYCStatus(msg.sender,now) == true);
    
    //On the Basis of ICO type we will have checks for specific Investor
   require(AccreditationInfo.checkInvestorValidity(msg.sender,now, ICOType) == true);
    
   require(msg.value > 0);
   require (msg.value >= MinimumContributionPreSale);
   require(msg.value <= MaximumContributionPreSale);

   if(PreSaleOn)
    {

         require(inPreSalePeriod(now) == true); 
         uint256 newPurchaseRate  = purchaseRate.add((purchaseRate.mul(Discount)).div(100));
         uint256 tokens = newPurchaseRate.mul(msg.value); 
         tokens.add(BonusAmountPreSale); 

          require(CheckIfHardcapAchived(tokens) == true);

          InvestorBalances[msg.sender] = tokens;   
          CalculatetokenWithMailSalePeriod[msg.sender] = false;
    }
    else  //MainSale
    {
      
        uint256 mainSaleToken = purchaseRate.mul(msg.value);
        require(CheckIfHardcapAchived(mainSaleToken) == true);
        InvestorBalances[msg.sender] = mainSaleToken;  
        CalculatetokenWithMailSalePeriod[msg.sender] = true;

    }

   
  }
  

function GetTokenAmount(address addr) onlyTokenOwner(owner) view public returns(uint256)
{
    return InvestorBalances[addr];
}

function () external payable  
{
  
   
    calculateTokenmount();
   //Do not calculte anything here simply tranfer the money to the ower.

   FundDepositAddress.transfer(msg.value); 
  
}


  function DistributeToken(address AddrOfInvestor, uint256 currenttime,uint256 expiryDateTime, uint8 MainSalePeriodIndex) onlyTokenOwner(owner) public
  {

      require(AddrOfInvestor != 0x0);
      require(currenttime >0);
      require(expiryDateTime > 0);

       
        if(MainSalePeriodIndex == 0)  //PreSale
        {
          
        require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);

        uint256 tokens = InvestorBalances[AddrOfInvestor];

        internaltransfer(AddrOfInvestor,tokens);

         AccreditationInfo.SetLockingPeriodAndToken(AddrOfInvestor,expiryDateTime,tokens,ICOType); 

         InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy  
            
        }
        else
        {
            //Calculate token amount
            if(CheckIfMainSaleOn(MainSalePeriodIndex) == true)
            {
                uint256 bonusamount = GetBonusDetails(MainSalePeriodIndex);
                uint256 FinalToken = InvestorBalances[AddrOfInvestor].add(bonusamount); 
                require(CheckIfHardcapAchived(FinalToken) == true);
                require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);
                AccreditationInfo.SetLockingPeriodAndToken(AddrOfInvestor,expiryDateTime,FinalToken,ICOType);

                internaltransfer(AddrOfInvestor,FinalToken);

                InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy
             }              
        }

  }

  

  //This method will be called when investor  wants to tranfer token to other.  
function transfer(address newInvestor, uint256 tokens) public returns (bool) 
  {     

     require(CheckIfHardcapAchived(tokens) == true);
        
     //check KYC info of both Investor and Token Provider
     require(InvestorKYCInfo.CheckKYCStatus(msg.sender,now) == true); 
      require(InvestorKYCInfo.CheckKYCStatus(newInvestor,now) == true); 


     //Now If ICO Type is RegSRegD  then also we have to make sure that RegD is only Tranferring to RegD
     //check whether new investor is Accredated 
      require(AccreditationInfo.checkBothInvestorValidity(msg.sender,newInvestor,now, ICOType) == true); 
          
      uint256 TokenLockExpiryRegS =  AccreditationInfo.GetTokenLockExpiryDateTimeRegS(msg.sender,ICOType);
      if(TokenLockExpiryRegS > 0)
      {
         AccreditationInfo.SetLockingPeriodAndToken(newInvestor,TokenLockExpiryRegS,tokens,ICOType); 
      }
    
        internaltransfer(newInvestor,tokens);
       // emit Transfer(msg.sender, newInvestor, tokens);

        
  }
  

function setKYCAndAccridetionAddres(address _kyc, address _InvestorAcrridetion ) public {

	
	BrightCoinInvestorKYCAddress = _kyc;
	BrightCoinInvestorAccreditationAddress = _InvestorAcrridetion;

    InvestorKYCInfo = BrightCoinInvestorKYC(_kyc);
    AccreditationInfo = BrightCoinInvestorAccreditationCheck(_InvestorAcrridetion);
    
    }	


    function GetCurrentKYCCount() view public  returns(uint256)
    {

    	return InvestorKYCInfo.GetKYCCount();
    }








	
}