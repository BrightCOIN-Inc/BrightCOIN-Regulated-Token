
pragma solidity ^0.4.24;
//pragma experimental "v0.5.0";

import "./BrightCoinInvestorKYC.sol";
import "./BrightCoinTokenOwner.sol";
import "./BrightCoinERC20Contract.sol";
import  "./BrightCoinInvestorCheck.sol";



//Rules for Accredited Investors
/*
 This is special BrightCoinToken that will allow User to invest to Token Only after Proper Checks and Validation as provide by US Regulatories Authorities
*/

/*
 import all specific contract that will help in Validation 
 Accridetion
 KYC
 TokenDistribution Details
*/

contract BrightCoinRegulatedToken  is BrightCoinERC20
{

BrightCoinInvestorKYC InvestorKYCInfo;
BrightCoinInvestorCheck AccreditationInfo;


address public BrightCoinInvestorKYCAddress; 
address public BrightCoinInvestorAccreditationAddress; 
mapping(address => uint256) private InvestorBalances;
bool InvestorSecurity;
bool KYCSupport;

constructor() public 
{
 InvestorSecurity = false;
 KYCSupport = false;
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
    
 if(InvestorSecurity == true)
    {
        //On the Basis of ICO type we will have checks for specific Investor
        require(AccreditationInfo.checkInvestorValidity(msg.sender, ICOType) == true);
   }
    
   require(msg.value > 0);
   require (msg.value >= MinimumContribution);
   require(msg.value <= MaximumContribution);

   
   if((PreSaleOn == true) && (saleIndex == 0)) //Presale
   {
         uint256 newPurchaseRate  = purchaseRate.add((purchaseRate.mul(Discount)).div(100));
         uint256 tokens = newPurchaseRate.mul(msg.value); 
         tokens.add(BonusAmountPreSale); 

         uint256 preSaleFinalToken = allowed[msg.sender][owner()].add(tokens);
        require(preSaleFinalToken <= getMaxCoinSoldDuringPreSale(decimals));
        require(CheckIfHardcapAchived(preSaleFinalToken) == true);  // to be fix 

        InvestorBalances[msg.sender] =  preSaleFinalToken;  
    
          
      }
    else  //MainSale
    {
       
        //check if mainSale of that period is ON 
        uint8 mainSaleIndex = getSalePeriodIndex();
        require(CheckIfMainSaleOn(mainSaleIndex) == true, "Main Sale for this period is off ");

        //Now get bonus and discount and calculate final toke to be given .
        uint256 mainsaleDiscount =  getMainSaleDiscount(mainSaleIndex);
        uint256 mainSalePurchaseRate  = purchaseRate.add((purchaseRate.mul(mainsaleDiscount)).div(100));
        uint256 finalTokenMainSale = mainSalePurchaseRate.mul(msg.value);

        uint256 tokenVerifyLimit = InvestorBalances[msg.sender].add(finalTokenMainSale);
        require(CheckMainSaleLimit(mainSaleIndex,tokenVerifyLimit,decimals) == true, "Main Sale Limit Crossed");
        require(CheckIfHardcapAchived(tokenVerifyLimit) == true);

       InvestorBalances[msg.sender] = tokenVerifyLimit;//InvestorBalances[msg.sender].add(finalTokenMainSale);  
    
    }

  }
  

//This methos is for testing purpose to be removed before deployment
function GetTokenAmount(address _addr) onlyTokenOwner view public returns(uint256)
{
    return InvestorBalances[_addr];
}

function () external payable  
{
   require(pauseICO == false);  //if this flag is true the no operation is allowed.
   calculateTokenmount(); //Calculate the token to be sent and store it.
   FundDepositAddress.transfer(msg.value);  //Send Ether to Specified address
  
}


  function DistributeToken(address AddrOfInvestor, uint256 currenttime,
                    uint256 tokenlockPeriod, uint8 MainSalePeriodIndex) onlyTokenOwner public
  {

      require(AddrOfInvestor != 0x0);
      require(currenttime >0);
      require(tokenlockPeriod > 0);

     uint256 tokenTimeLock = now.add(tokenlockPeriod);
       
        if((MainSalePeriodIndex == 0) && (PreSaleOn == true))  //PreSale
        {
        
        if(InvestorSecurity == true)
        {
         require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,ICOType) == true);
        }

        uint256 tokens = InvestorBalances[AddrOfInvestor];
      
       internaltransfer(AddrOfInvestor,tokens);
       SetTokenLock(AddrOfInvestor,tokenTimeLock,tokens);
        InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy  
            
        }
        else
        {
            //Calculate token amount
            if(CheckIfMainSaleOn(MainSalePeriodIndex) == true)
            {

              require(CheckTokenPeriodSale(currenttime,MainSalePeriodIndex) == true);
              if(InvestorSecurity == true)
              {
                require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,ICOType) == true);    
              }

                uint256 MainSaletokens = InvestorBalances[AddrOfInvestor];
                internaltransfer(AddrOfInvestor,MainSaletokens);
                SetTokenLock(AddrOfInvestor,tokenTimeLock,MainSaletokens);
                InvestorBalances[AddrOfInvestor] = 0; //To avoid re-entrancy
             }              
        }

  }


  //This method will be called when investor  wants to tranfer token to other.  
function transfer(address _newInvestor, uint256 _tokens) public returns (bool) 
 {     
       require(pauseICO == false);  //if this flag is true the no operation is allowed.
      if(KYCSupport == true)
      {
        //check KYC info of newInvestor  and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(_newInvestor,now) == true); 
      }


      //check if locking period is expired or not 
      uint256 currenttime = now;
      
      if (InvestorSecurity == true)
      {
          
           if(isTokenLockExpire(msg.sender,currenttime) == true)
           {
               internaltransfer(_newInvestor,_tokens);
                return true;
           }
           
           uint256 TokenLockExpiry = getTokenLockExpiry(msg.sender); 
           require(TokenLockExpiry !=0);
         
         if( ICOType != uint8(BrightCoinICOType.Utility))
         {
            require(AccreditationInfo.checkBothInvestorValidity(msg.sender,_newInvestor, ICOType) == true); 
            SetTokenLock(_newInvestor,TokenLockExpiry,_tokens);
            internaltransfer(_newInvestor,_tokens);
            return true; 
         }
         else
         {
          SetTokenLock(_newInvestor,TokenLockExpiry,_tokens);
           internaltransfer(_newInvestor,_tokens);
           return true;
         }
            
      }
      else
      {
         require(isTokenLockExpire(msg.sender,currenttime) == true);
         internaltransfer(_newInvestor,_tokens);
         return true;
      }
      
      
}
      

function setKYCAndAccridetionAddres(address _kyc, 
                      address _InvestorAcrridetion ) onlyTokenOwner public 
{

	
	BrightCoinInvestorKYCAddress = _kyc;
	BrightCoinInvestorAccreditationAddress = _InvestorAcrridetion;

    InvestorKYCInfo = BrightCoinInvestorKYC(_kyc);
    AccreditationInfo = BrightCoinInvestorCheck(_InvestorAcrridetion);
    
}




function GetCurrentKYCCount() view public  returns(uint256)
{

  return InvestorKYCInfo.GetKYCCount();
}


//Set the KYC check implementation
function setKYCSupport(bool _kycSupportAcquired) onlyTokenOwner public
{
  KYCSupport = _kycSupportAcquired;
}

//Set the Accridition check implementation
function setInvestorSecuritySupport(bool _securitySupport) onlyTokenOwner public
{
  InvestorSecurity = _securitySupport;
}


 //Function to Distribute token to Admin.
 function DistributeTokentoAdmin(address _addr , uint256 _tokens, 
                      uint256 _lockExpiryDateTime,uint8 _adminType ) onlyTokenOwner public returns(bool)
 {
   require(_tokens !=0);
   require(_addr != 0x0);
   require(_lockExpiryDateTime > 0);
   
   uint256 lockexpiry;

 bool Addrexists= isAddrExists(_addr);
 if(!Addrexists)
 {
    require(InterTransferToAdmin(_addr,_tokens,_adminType) == true);
    lockexpiry = now.add(_lockExpiryDateTime);
    AddAdminToken(_addr,_tokens,lockexpiry,true,_adminType);
     emit Transfer(msg.sender, _addr, _tokens);
    SetTokenLock(_addr,lockexpiry,_tokens);
     
  }
  else
 {
      require(InterTransferToAdmin(_addr,_tokens,_adminType) == true);
        //Transfer Founder token
      lockexpiry = now.add(_lockExpiryDateTime);
      UpdateAdminTokenDetails(_addr,_tokens,lockexpiry,_adminType);
      emit Transfer(msg.sender, _addr, _tokens);
     IncreaseTokenAmount(_addr,lockexpiry,_tokens);
  
  }

  return true;

 }

 
  
  function TransferTokenBountyOwner() onlyTokenOwner public
  {
  
      allowed[msg.sender][BountyTokenHolder]  = balances[BountyTokenHolder];
  
 
  }
  
 
  //Transfer Bounty token from To Bounty Holder to Bounty Hunters
 function TransferBountyToken(address _from , address _addr, uint256 _token, uint256 _lockExpiry,
                  bool _locked)  public returns(bool)
   {

     require(_token != 0);
     require(_lockExpiry > 0);
     require(_from == BountyTokenHolder);
    require( InternalTransferfrom(_from, _addr,_token) == true, "Token Not Available");
   
     //now check if lock to provided or not
     if(_locked == true)
     {
          //Setlocking for the Bounty Account
       SetTokenLock(_addr, _lockExpiry,_token);
     }
     else
      {
       SetTokenLock(_addr, 0,_token); //Token details set with no locking period
      }
      

   }
   
   

   function TransferCompanyHoldingTokens(uint256 _lockExpiry)  public onlyTokenOwner  returns(bool)
  { 
    
      require(CompanyHoldingBalances[msg.sender] == CompanyHoldingValue) ; 
      uint256 Holdinglockexpiry = now.add(_lockExpiry);
     
      balances[CompanyHoldingAddress] = CompanyHoldingBalances[msg.sender];
    CompanyHoldingBalances[msg.sender] = 0;
   SetTokenLock(CompanyHoldingAddress,Holdinglockexpiry,CompanyHoldingValue);
      emit Transfer(msg.sender, CompanyHoldingAddress, CompanyHoldingValue);
      return true;

 } 


}