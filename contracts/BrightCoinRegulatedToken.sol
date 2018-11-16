
pragma solidity ^0.4.25;

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
function GetTokenAmount(address _addr)view public  onlyTokenOwner  returns(uint256)
{
    return InvestorBalances[_addr];
}

function () external payable  
{
   require(pauseICO == false);  //if this flag is true the no operation is allowed.
   calculateTokenmount(); //Calculate the token to be sent and store it.
   FundDepositAddress.transfer(msg.value);  //Send Ether to Specified address
  
}


  function DistributeToken(address _addrOfInvestor, uint256 _currenttime,
                    uint256 _tokenlockPeriod, uint8 _mainSalePeriodIndex) public onlyTokenOwner 
  {

      require(_addrOfInvestor != 0x0);
      require(_currenttime >0);
      require(_tokenlockPeriod > 0);

     uint256 tokenTimeLock = now.add(_tokenlockPeriod);
       
        if((_mainSalePeriodIndex == 0) && (PreSaleOn == true))  //PreSale
        {
        
        if(InvestorSecurity == true)
        {
         require(AccreditationInfo.checkInvestorValidity(_addrOfInvestor,ICOType) == true);
        }

        uint256 tokens = InvestorBalances[_addrOfInvestor];
      
       internaltransfer(msg.sender,_addrOfInvestor,tokens);
       SetTokenLock(_addrOfInvestor,tokenTimeLock,tokens);
        InvestorBalances[_addrOfInvestor] = 0; //To avoid re-entrancy  
            
        }
        else
        {
            //Calculate token amount
            if(CheckIfMainSaleOn(_mainSalePeriodIndex) == true)
            {

              require(CheckTokenPeriodSale(_currenttime,_mainSalePeriodIndex) == true);
              if(InvestorSecurity == true)
              {
                require(AccreditationInfo.checkInvestorValidity(_addrOfInvestor,ICOType) == true);    
              }

                uint256 MainSaletokens = InvestorBalances[_addrOfInvestor];
                internaltransfer(msg.sender,_addrOfInvestor,MainSaletokens);
                SetTokenLock(_addrOfInvestor,tokenTimeLock,MainSaletokens);
                InvestorBalances[_addrOfInvestor] = 0; //To avoid re-entrancy
             }              
        }

  }

  function checkCompliance(address _investor) view private  returns(bool)
{
     if(KYCSupport == true)
      {
        //check KYC info of newInvestor  and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(_investor,now) == true); 
      }
    if(InvestorSecurity == true)
      {
         require(AccreditationInfo.checkInvestorValidity(_investor,ICOType) == true);
      }

      return true;
}

function regulatedtransfer( address _from , address _to, uint256 _tokens) private returns(bool) 
{
    //check if locking period is expired or not 
      uint256 currenttime = now;
      
      if (InvestorSecurity == true)
      {
          
           if(isTokenLockExpire(_from,currenttime) == true)
           {
               internaltransfer(_from,_to,_tokens);
                return true;
           }
           
           uint256 TokenLockExpiry = getTokenLockExpiry(_from); 
           require(TokenLockExpiry !=0);
         
         if( ICOType != uint8(BrightCoinICOType.Utility))
         {
            require(AccreditationInfo.checkBothInvestorValidity(_from,_to, ICOType) == true); 
            SetTokenLock(_to,TokenLockExpiry,_tokens);
            internaltransfer(_from,_to,_tokens);
            return true; 
         }
         else
         {
          SetTokenLock(_to,TokenLockExpiry,_tokens);
           internaltransfer(_from,_to,_tokens);
           return true;
         }
            
      }
      else
      {
         require(isTokenLockExpire(msg.sender,currenttime) == true);
         internaltransfer(_from,_to,_tokens);
         return true;
      }
      
}

function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) 
{
      
       require(pauseICO == false);  //if this flag is true the no operation is allowed.
      require(_tokens > 0);
      require(allowed[_from][msg.sender] >= _tokens);
     // require(checkCompliance(_to) == true);
     if(KYCSupport == true)
      {
        //check KYC info of newInvestor  and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(_to,now) == true); 
      }
      require(regulatedtransfer(_from ,_to,_tokens) == true);
      //If regulated transfer is true then only reduce allowed map
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_tokens);
      return true;
}
    

function approve(address _spender, uint256 _value) public returns (bool success)
 {
     require(_spender != address(0));
      require(checkCompliance(_spender) == true);
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      
      return true;
 }
  //This method will be called when investor  wants to tranfer token to other.  
function transfer(address _to, uint256 _tokens) public returns (bool) 
 {     
      require(pauseICO == false);  //if this flag is true the no operation is allowed.
      require(_to != address(0));
      if(KYCSupport == true)
      {
        //check KYC info of newInvestor  and Token Provider 
        require(InvestorKYCInfo.CheckKYCStatus(_to,now) == true); 
      }

      require(regulatedtransfer(msg.sender, _to, _tokens) == true); 
       
      
}
      

function setKYCAndAccridetionAddres(address _kyc, 
                      address _investorAcrridetion ) public onlyTokenOwner  
{

	
	BrightCoinInvestorKYCAddress = _kyc;
	BrightCoinInvestorAccreditationAddress = _investorAcrridetion;

    InvestorKYCInfo = BrightCoinInvestorKYC(_kyc);
    AccreditationInfo = BrightCoinInvestorCheck(_investorAcrridetion);
    
}




function GetCurrentKYCCount() view public  returns(uint256)
{

  return InvestorKYCInfo.GetKYCCount();
}


//Set the KYC check implementation
function setKYCSupport(bool _kycSupportAcquired) public onlyTokenOwner 
{
  KYCSupport = _kycSupportAcquired;
}

//Set the Accridition check implementation
function setInvestorSecuritySupport(bool _securitySupport) public onlyTokenOwner 
{
  InvestorSecurity = _securitySupport;
}


 //Function to Distribute token to Admin.
 function DistributeTokentoAdmin(address _addr , uint256 _tokens, 
                      uint256 _lockExpiryDateTime,uint8 _adminType ) public onlyTokenOwner  returns(bool)
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

 
  
  function TransferTokenBountyOwner() public onlyTokenOwner 
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
   
   

   function TransferCompanyHoldingTokens(uint256 _lockExpiry) public onlyTokenOwner     returns(bool)
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