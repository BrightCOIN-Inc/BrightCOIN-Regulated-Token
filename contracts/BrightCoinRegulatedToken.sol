
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
 Accridetion
 KYC
 TokenDistribution Details
*/

contract BrightCoinRegulatedToken  is BrightCoinERC20
{

BrightCoinInvestorKYC InvestorKYCInfo;
BrightCoinInvestorAccreditationCheck AccreditationInfo;
//BrightCoinTokenLock  TokenLockDetails;

address public BrightCoinInvestorKYCAddress; 
address public BrightCoinInvestorAccreditationAddress; 
mapping(address => uint256) private InvestorBalances;
mapping(address => bool) private CalculatetokenWithMainSalePeriod;
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
   require (msg.value >= MinimumContribution);
   require(msg.value <= MaximumContribution);

   if(inPreSalePeriod(now))
    {
         uint256 newPurchaseRate  = purchaseRate.add((purchaseRate.mul(Discount)).div(100));
         uint256 tokens = newPurchaseRate.mul(msg.value); 
         tokens.add(BonusAmountPreSale); 

         uint256 preSaleFinalToken = InvestorBalances[msg.sender].add(tokens);
        require(preSaleFinalToken <= getMaxCoinSoldDuringPreSale(decimals));
         require(CheckIfHardlimitAchived(preSaleFinalToken) == true);  // to be fix 

         InvestorBalances[msg.sender] =  preSaleFinalToken;   
          CalculatetokenWithMainSalePeriod[msg.sender] = false;
      }
    else  //MainSale
    {
        uint8 mainSalePeriodIndex = checkMainSalePeriod(now);
        require(mainSalePeriodIndex > 0, "Main Sale Period not started");

        //check if mainSale of that period is ON 
        require(CheckIfMainSaleOn(mainSalePeriodIndex) == true, "Main Sale for this period is off ");

        //Now get bonus and discount and calculate final toke to be given .
        uint256 mainsaleDiscount =  getMainSaleDiscount(mainSalePeriodIndex);
        uint256 mainSalePurchaseRate  = purchaseRate.add((purchaseRate.mul(mainsaleDiscount)).div(100));
        uint256 finalTokenMainSale = mainSalePurchaseRate.mul(msg.value);

        uint256 tokenVerifyLimit = InvestorBalances[msg.sender].add(finalTokenMainSale);
        require(CheckMainSaleLimit(mainSalePeriodIndex,tokenVerifyLimit,decimals) == true, "Main Sale Limit Crossed");
        require(CheckIfHardlimitAchived(tokenVerifyLimit) == true);

       InvestorBalances[msg.sender] = InvestorBalances[msg.sender].add(finalTokenMainSale);  
        CalculatetokenWithMainSalePeriod[msg.sender] = true;
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
        
        if(AccridetionSupport == true)
        {
         require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);
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
              if(AccridetionSupport == true)
              {
                require(AccreditationInfo.checkInvestorValidity(AddrOfInvestor,currenttime,ICOType) == true);    
              }

              SetTokenLock(AddrOfInvestor,tokenTimeLock,InvestorBalances[AddrOfInvestor]);

                internaltransfer(AddrOfInvestor,InvestorBalances[AddrOfInvestor]);
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
        //check KYC info of both Investor and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(newInvestor,now) == true); 
      }

      //check if locking period is expired or not 
     // uint256 currenttime = now + 250 seconds;//For Testing Code to be removed
       uint256 currenttime = now;

       bool retVal =  isTokenLockExpire(msg.sender,currenttime);
       if(retVal == true)  //If lock expired then no other check reqired and simply transfer token
      {
          internaltransfer(newInvestor,tokens);
          return true;
      }

      uint256 TokenLockExpiry = getTokenLockExpiry(msg.sender); 
       if (AccridetionSupport == true)
      {
         if( ICOType != uint8(BrightCoinICOType.Utility))
         {
            require(AccreditationInfo.checkBothInvestorValidity(msg.sender,newInvestor,currenttime, ICOType) == true); 
            require(TokenLockExpiry !=0);
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
      

  }
  

function setKYCAndAccridetionAddres(address _kyc, 
                      address _InvestorAcrridetion ) onlyTokenOwner public 
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


 //Function to Distribute token to Admin.
 function DistributeTokentoAdmin(address addr , uint256 tokens, 
                      uint256 LockExpiryDateTime,uint8 AdminType ) onlyTokenOwner public returns(bool)
 {
   
   //Transfer Founder token
   uint256 lockexpiry = now.add(LockExpiryDateTime);

 bool Addrexists= isAddrExists(addr);
 if(!Addrexists)
 {
      require(TokenAvailableForAdmin(addr,balances[addr],tokens,AdminType) == true);
      AddAdminToken(addr,tokens,lockexpiry,true,AdminType);
      SetTokenLock(addr,lockexpiry,tokens);
      balances[addr] = tokens;
  }
  else
  {
      require(TokenAvailableForAdmin(addr,balances[addr],tokens,AdminType) == true);
      UpdateAdminTokenDetails(addr,tokens,lockexpiry,AdminType);
      IncreaseTokenAmount(addr,lockexpiry,tokens);
      balances[addr] = balances[addr].add(tokens);
  }

  return true;

 }

 
  function TranferCompanyHoldingTokens(uint256 lockExpiry)  onlyTokenOwner public returns(bool)
  { 

      uint256 Holdinglockexpiry = now.add(lockExpiry);
      balances[CompanyHoldingAddress] = CompanyHoldingValue;
       SetTokenLock(CompanyHoldingAddress,Holdinglockexpiry,CompanyHoldingValue);
      
      return true;


 } 

  function TransferTokenBountyOwner() onlyTokenOwner public
  {
      require(BountyAllocated !=0 );
      balances[BountyTokenHolder] = BountyAllocated;
  }

 function TransferBountyToken(address addr, uint256 _token, uint256 lockExpiry,
                  bool locked) onlyBountyTokenOwner public returns(bool)
   {

     require(_token != 0);
     require(lockExpiry > 0);
     require( TokenAvailableForBounty(balances[BountyTokenHolder],_token) == true, "Token Not Available");
   
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
      internaltransfer(addr,_token);


   }

   

}