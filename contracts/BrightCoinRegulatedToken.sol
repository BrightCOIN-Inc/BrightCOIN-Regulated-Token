
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
        require(CheckIfHardlimitAchived(preSaleFinalToken) == true);  // to be fix 

        InvestorBalances[msg.sender] =  preSaleFinalToken;  
    
          
      }
    else  //MainSale
    {
       
        //check if mainSale of that period is ON 
        uint256 mainSaleIndex = getSalePeriodIndex();
        require(CheckIfMainSaleOn(mainSaleIndex) == true, "Main Sale for this period is off ");

        //Now get bonus and discount and calculate final toke to be given .
        uint256 mainsaleDiscount =  getMainSaleDiscount(mainSaleIndex);
        uint256 mainSalePurchaseRate  = purchaseRate.add((purchaseRate.mul(mainsaleDiscount)).div(100));
        uint256 finalTokenMainSale = mainSalePurchaseRate.mul(msg.value);

        uint256 tokenVerifyLimit = InvestorBalances[msg.sender].add(finalTokenMainSale);
        require(CheckMainSaleLimit(mainSaleIndex,tokenVerifyLimit,decimals) == true, "Main Sale Limit Crossed");
        require(CheckIfHardlimitAchived(tokenVerifyLimit) == true);

       InvestorBalances[msg.sender] = tokenVerifyLimit;//InvestorBalances[msg.sender].add(finalTokenMainSale);  
    
    }

  }
  

//This methos is for testing purpose to be removed before deployment
function GetTokenAmount(address addr) onlyTokenOwner view public returns(uint256)
{
    return InvestorBalances[addr];
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
function transfer(address newInvestor, uint256 tokens) public returns (bool) 
 {     
       require(pauseICO == false);  //if this flag is true the no operation is allowed.
      if(KYCSupport == true)
      {
        //check KYC info of newInvestor  and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(newInvestor,now) == true); 
      }


      //check if locking period is expired or not 
      uint256 currenttime = now;
      
      if (InvestorSecurity == true)
      {
          
           if(isTokenLockExpire(msg.sender,currenttime) == true)
           {
               internaltransfer(newInvestor,tokens);
                return true;
           }
           
           uint256 TokenLockExpiry = getTokenLockExpiry(msg.sender); 
           require(TokenLockExpiry !=0);
         
         if( ICOType != uint8(BrightCoinICOType.Utility))
         {
            require(AccreditationInfo.checkBothInvestorValidity(msg.sender,newInvestor, ICOType) == true); 
            SetTokenLock(newInvestor,TokenLockExpiry,tokens);
            internaltransfer(newInvestor,tokens);
            return true; 
         }
         else
         {
          SetTokenLock(newInvestor,TokenLockExpiry,tokens);
           internaltransfer(newInvestor,tokens);
           return true;
         }
            
      }
      else
      {
         require(isTokenLockExpire(msg.sender,currenttime) == true);
         internaltransfer(newInvestor,tokens);
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
function setKYCSupport(bool KYCSupportAcquired) onlyTokenOwner public
{
  KYCSupport = KYCSupportAcquired;
}

//Set the Accridition check implementation
function setInvestorSecuritySupport(bool securitySupport) onlyTokenOwner public
{
  InvestorSecurity = securitySupport;
}


 //Function to Distribute token to Admin.
 function DistributeTokentoAdmin(address addr , uint256 tokens, 
                      uint256 LockExpiryDateTime,uint8 AdminType ) onlyTokenOwner public returns(bool)
 {
   require(tokens !=0);
   require(addr != 0x0);
   require(LockExpiryDateTime > 0);
   
   uint256 lockexpiry;

 bool Addrexists= isAddrExists(addr);
 if(!Addrexists)
 {
    require(InterTransferToAdmin(addr,tokens,AdminType) == true);
    lockexpiry = now.add(LockExpiryDateTime);
    AddAdminToken(addr,tokens,lockexpiry,true,AdminType);
     emit Transfer(msg.sender, addr, tokens);
    SetTokenLock(addr,lockexpiry,tokens);
     
  }
  else
 {
      require(InterTransferToAdmin(addr,tokens,AdminType) == true);
        //Transfer Founder token
      lockexpiry = now.add(LockExpiryDateTime);
      UpdateAdminTokenDetails(addr,tokens,lockexpiry,AdminType);
      emit Transfer(msg.sender, addr, tokens);
     IncreaseTokenAmount(addr,lockexpiry,tokens);
  
  }

  return true;

 }

 
  
  function TransferTokenBountyOwner() onlyTokenOwner public
  {
  
      allowed[msg.sender][BountyTokenHolder]  = balances[BountyTokenHolder];
  
 
  }
  
 
  //Transfer Bounty token from To Bounty Holder to Bounty Hunters
 function TransferBountyToken(address _from , address addr, uint256 _token, uint256 lockExpiry,
                  bool locked)  public returns(bool)
   {

     require(_token != 0);
     require(lockExpiry > 0);
     require(_from == BountyTokenHolder);
    require( InternalTransferfrom(_from, addr,_token) == true, "Token Not Available");
   
     //now check if lock to provided or not
     if(locked == true)
     {
          //Setlocking for the Bounty Account
       SetTokenLock(addr, lockExpiry,_token);
     }
     else
      {
       SetTokenLock(addr, 0,_token); //Token details set with no locking period
      }
      

   }
   
   

   function TransferCompanyHoldingTokens(uint256 lockExpiry)  onlyTokenOwner public returns(bool)
  { 
    
      require(CompanyHoldingBalances[msg.sender] == CompanyHoldingValue) ; 
      uint256 Holdinglockexpiry = now.add(lockExpiry);
     
      balances[CompanyHoldingAddress] = CompanyHoldingBalances[msg.sender];
    CompanyHoldingBalances[msg.sender] = 0;
   SetTokenLock(CompanyHoldingAddress,Holdinglockexpiry,CompanyHoldingValue);
      emit Transfer(msg.sender, CompanyHoldingAddress, CompanyHoldingValue);
      return true;

 } 


}