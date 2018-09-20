
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
bool AccridetionSupport;
bool KYCSupport;

constructor() public 
{

AccridetionSupport = true;
KYCSupport = true;
	
}

function GetCurrentTime() view public returns(uint256)
{
    return now;
}

//Calculate Token Amount to be Provided.   
function calculateTokenmount()  private {
  
  if(KYCSupport == true)  //Check if ICO New KYC Check of Investor
  {
     require(InvestorKYCInfo.CheckKYCStatus(msg.sender,now) == true);
  }
    
    if(AccridetionSupport == true)
    {
        //On the Basis of ICO type we will have checks for specific Investor
        require(AccreditationInfo.checkInvestorValidity(msg.sender,now, ICOType) == true);
   }
    
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

         InvestorBalances[msg.sender] =  InvestorBalances[msg.sender].add(tokens);   
          CalculatetokenWithMailSalePeriod[msg.sender] = false;
          

    }
    else  //MainSale
    {
      
       uint256 mainSaleToken = purchaseRate.mul(msg.value);
      // require(CheckIfHardcapAchived(mainSaleToken) == true);
       InvestorBalances[msg.sender] = mainSaleToken;  
        CalculatetokenWithMailSalePeriod[msg.sender] = true;

    }

    

   
  }
  

function GetTokenAmount(address addr) onlyTokenOwner view public returns(uint256)
{
    return InvestorBalances[addr];
}

function () external payable  
{

   require(isICOActive == true);

  calculateTokenmount();
   //Do not calculte anything here simply tranfer the money to the ower.

   FundDepositAddress.transfer(msg.value); 
  
}


  function DistributeToken(address AddrOfInvestor, uint256 currenttime,uint256 expiryDateTime, uint8 MainSalePeriodIndex) onlyTokenOwner public
  {

      require(AddrOfInvestor != 0x0);
      require(currenttime >0);
      require(expiryDateTime > 0);

       
        if((MainSalePeriodIndex == 0) && (PreSaleOn == true))  //PreSale
        {
        
        if(AccridetionSupport == true)
        {
          require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);
        }

        uint256 tokens = InvestorBalances[AddrOfInvestor];

       internaltransfer(AddrOfInvestor,tokens);

        if(AccridetionSupport == true)
        {
          AccreditationInfo.SetLockingPeriodAndToken(AddrOfInvestor,expiryDateTime,tokens,ICOType); 
        }

         InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy  
            
        }
        else
        {
            //Calculate token amount
            if(CheckIfMainSaleOn(MainSalePeriodIndex) == true)
            {

              require(CheckTokenPeriodSale(currenttime,MainSalePeriodIndex) == true);

                uint256 bonusamount = GetBonusDetails(MainSalePeriodIndex);
                uint256 FinalToken = InvestorBalances[AddrOfInvestor].add(bonusamount); 
                //Need to check whether Token amount is in the range of current Main sale Period 
               // require(CheckMainSaleLimit(MainSalePeriodIndex,FinalToken) == true);
          
              if(AccridetionSupport == true)
              {
                require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);
                AccreditationInfo.SetLockingPeriodAndToken(AddrOfInvestor,expiryDateTime,FinalToken,ICOType);
              }

                internaltransfer(AddrOfInvestor,FinalToken);
                InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy
             }              
        }

  }

  

  //This method will be called when investor  wants to tranfer token to other.  
function transfer(address newInvestor, uint256 tokens) public returns (bool) 
  {     

      
      if(KYCSupport == true)
      {
        //check KYC info of both Investor and Token Provider
        require(InvestorKYCInfo.CheckKYCStatus(msg.sender,now) == true); 
        require(InvestorKYCInfo.CheckKYCStatus(newInvestor,now) == true); 
      }


    if(AccridetionSupport == true)
    {
      //check if locking period is expired or not 
      //uint256 currenttime = now + 1 years;  //For Testing Code to be removed
        uint256 currenttime = now;

      if( ICOType != uint8(BrightCoinICOType.Utility))
      {
        uint256 TokenLockExpiry =  AccreditationInfo.GetTokenLockExpiryDateTime(msg.sender,ICOType);
        if(currenttime < TokenLockExpiry)  // then it can only transfer token to Accriteded Investor only
        {
          require(AccreditationInfo.checkBothInvestorValidity(msg.sender,newInvestor,currenttime, ICOType) == true); 
          AccreditationInfo.SetLockingPeriodAndToken(newInvestor,TokenLockExpiry,tokens,ICOType);
            
        }
      }
      else
      {
          require(AccreditationInfo.checkBothInvestorValidity(msg.sender,newInvestor,currenttime, ICOType) == true); 

      }
    }

     internaltransfer(newInvestor,tokens);
    //emit Transfer(msg.sender, newInvestor, tokens);

     

  }
  

function setKYCAndAccridetionAddres(address _kyc, address _InvestorAcrridetion ) onlyTokenOwner public 
{

	
	BrightCoinInvestorKYCAddress = _kyc;
	BrightCoinInvestorAccreditationAddress = _InvestorAcrridetion;

  InvestorKYCInfo = BrightCoinInvestorKYC(_kyc);
  AccreditationInfo = BrightCoinInvestorAccreditationCheck(_InvestorAcrridetion);
    
}	


function GetCurrentKYCCount() view public  returns(uint256)
{

  return InvestorKYCInfo.GetKYCCount();
}


//Set the KYC check implementation
function setKYCSupport(bool KYCSupportAcquired) 
{
  KYCSupport = KYCSupportAcquired;
}

//Set the Accridition check implementation
function setAccridetionSupport(bool AccridetionSupportAcquired) 
{
  AccridetionSupport = AccridetionSupportAcquired;
}



}