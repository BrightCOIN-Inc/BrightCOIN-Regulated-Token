//Rules for Accredited Investors
/*
Reg D - 
For USA citizens only. 
These are for sale to accredited investors only .
(KYC/AML has to be done). 
There is a 1 year lockin period. 
The only exception is that one accredited investor can sell to another accredited investor. 

Reg A+ -  For USA citizens only. Anyone can invest. 
    The maximum that can be invested is $50Million per year. 
    KYC/AML is required.
     The max a person can invest in reg a+ is $17500 per year. 

Reg S -
 This is for USA companies raising money outside USA. 
 This can have a 6 Month or a 1 year lockin. 
 (KYC/AML has to be done). The other rule is that these tokens cannot be sold to a USA person for a 1 year period. 

NOTE- During any sale period a investor in USA can be offered reg d and reg a+. 
The investor has to choose and fill out paperwork to qualify. 

So the token has to be aware of the following:
WHO CAN BUY AND WHO CAN SELL
was it sold as a reg d. date of its sale.  Has to have to ability to unlock
was it sold as a reg a+ . date of sale
was it sold as reg S. date of sale. Is the lockin 6month or 1 year. During this period the token cannot unlock.
*/

/*

what location is the investor based in
Is this investor accredited. Time and date of accreditation (as it expires after x time)
is KYC/AML done. Time and date of KYC/AML (as it expires after x time)
Is there more data that can be stored here? eg: file numbers etc? post documents to blockchain etc?
How much has this investor invested in the past.

*/

pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinRegSInvestor.sol";
import "./BrightCoinRegDInvestor.sol";



contract BrightCoinInvestorAccreditationCheck is BrightCoinRegDInvestor(msg.sender),BrightCoinRegSInvestor(msg.sender)
{

enum BrightCoinInvestorType { RegD, RegS, RegDRegS, Utility }

address owner;
constructor() public
{
  owner = msg.sender;
}


 function checkBothInvestorValidity(address investor, address InvestorAddress, uint256 currentdatetime, uint8 ICOType)  public view returns(bool)
 {

    bool validityStatus = false;
    bool Investoevalidity = false;
    bool newInvestorvalidity = false;
 
    if(ICOType == uint8(BrightCoinInvestorType.RegD))
    {
      Investoevalidity = CheckAccreditionStatusRegD(investor,currentdatetime);
      newInvestorvalidity = CheckAccreditionStatusRegD(InvestorAddress,currentdatetime);
       if( Investoevalidity == newInvestorvalidity)
            return true;
    }
    else if (ICOType == uint8(BrightCoinInvestorType.RegS))
    {
  
      Investoevalidity = CheckAccreditionStatusRegS(investor,currentdatetime);
      newInvestorvalidity = CheckAccreditionStatusRegS(InvestorAddress,currentdatetime);
       if( Investoevalidity == newInvestorvalidity)
            return true;

    }
    else if(ICOType == uint8(BrightCoinInvestorType.RegDRegS))
    {
        //Do check for RegD and RegS stuff
        Investoevalidity = CheckAccreditionStatusRegD(investor,currentdatetime);
        newInvestorvalidity = CheckAccreditionStatusRegD(InvestorAddress,currentdatetime);

        if(Investoevalidity == newInvestorvalidity)
            return true;
        else
        {            
           Investoevalidity = CheckAccreditionStatusRegD(investor,currentdatetime);
           newInvestorvalidity = CheckAccreditionStatusRegD(InvestorAddress,currentdatetime);
           if(Investoevalidity == newInvestorvalidity)
            return true;
        }

        return validityStatus;

    }
    else  //Utility ICO 
    {
        //No check required
         return true;
    }


   return validityStatus;

 }


function checkInvestorValidity( address InvestorAddress, uint256 currentdatetime, uint8 ICOType)  public view returns(bool)
 {

    bool validityStatus = false;
  
 
    if(ICOType == uint8(BrightCoinInvestorType.RegD))
    {
      validityStatus = CheckAccreditionStatusRegD(InvestorAddress,currentdatetime);
       return validityStatus;
    }
    else if (ICOType == uint8(BrightCoinInvestorType.RegS))
    {
   
      validityStatus = CheckAccreditionStatusRegS(InvestorAddress,currentdatetime);
      return validityStatus;

    }
    else if(ICOType == uint8(BrightCoinInvestorType.RegDRegS))
    {
        //Do check for RegD and RegS stuff
        validityStatus = CheckAccreditionStatusRegD(InvestorAddress,currentdatetime);
        if(validityStatus == false)
        {            
           
           validityStatus = CheckAccreditionStatusRegS(InvestorAddress,currentdatetime);
           return validityStatus;
        }
        return validityStatus;

    }
    else  //Utility ICO 
    {
        //No check required
     }


   return true;

 }


 function SetLockingPeriodAndToken(address InvestorAddress, uint256 expiryDateTime, 
                                      uint256 tokenamount, uint8 ICOType) public
 {

  if(ICOType == uint8(BrightCoinInvestorType.RegD))
    {
      SetLockingPeriodRegD(InvestorAddress,expiryDateTime,tokenamount);
    }
    else if (ICOType == uint8(BrightCoinInvestorType.RegS))
    {

           SetLockingPeriodRegS(InvestorAddress,expiryDateTime,tokenamount);
    }
    else if(ICOType == uint8(BrightCoinInvestorType.RegDRegS))
    {
        //Do check for RegDand RegS stuff
        bool validityStatus = CheckAccreditionStatusRegD(InvestorAddress,now);
        if(validityStatus == false)
        {
            //It must be RegS Investor
         SetLockingPeriodRegS(InvestorAddress,expiryDateTime,tokenamount);
        }
        else
        SetLockingPeriodRegD(InvestorAddress,expiryDateTime,tokenamount);

    }
    else  //Utility ICO 
    {
       //Mo Locking period but do we need to store their amount transaction details
    }

 }

  function GetTokenLockExpiryDateTimeRegS(address senderAddr,uint8 ICOType ) public view returns(uint256)
  {
      uint256 lockingexpiryDate;

     if(ICOType == uint8(BrightCoinInvestorType.RegD))
    {
      lockingexpiryDate = GetTokenLockExpiryDateTimeRegD(senderAddr);
      return lockingexpiryDate;
    }
    else if(ICOType == uint8(BrightCoinInvestorType.RegDRegS))
    {

        //Do check for RegDand RegS stuff
        bool validityStatus = CheckAccreditionStatusRegD(senderAddr,now);
        if(validityStatus == false)
        {
            lockingexpiryDate = GetTokenLockExpiryDateTimeRegS(senderAddr);  //RegS Investor
            return lockingexpiryDate;
        }
        else
        {
            lockingexpiryDate = GetTokenLockExpiryDateTimeRegD(senderAddr);  //RegD Investor
             return lockingexpiryDate;
        }

    }
   else if(ICOType == uint8(BrightCoinInvestorType.RegS))
    {

        lockingexpiryDate = GetTokenLockExpiryDateTimeRegS(senderAddr);  //RegS Investor
        return lockingexpiryDate;

    }
    else
    {
        //Utility no expirydate
    }

    return 0;

   }

  
}


