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
import "./BrightCoinnonAccridetedInvestor.sol";
import "./BrightCoinAccreditionInvestor.sol";



contract BrightCoinInvestorAccreditationCheck is BrightCoinAccreditionInvestor,BrightCoinnonAccridetedInvestor
{

enum BrightCoinICOType { RegD, RegS, RegDRegS, Utility }


constructor() public
{
  
}


 function checkBothInvestorValidity(address investor, address InvestorAddress, uint8 ICOType)  public view returns(bool)
 {

   bool validityStatus = false;
    bool Investoevalidity = false;
    bool newInvestorvalidity = false;
 
    if(ICOType == uint8(BrightCoinICOType.RegD))
    {
      Investoevalidity = CheckAccreditionStatus(investor);
      newInvestorvalidity = CheckAccreditionStatus(InvestorAddress);
       if( Investoevalidity == newInvestorvalidity)
            return true;
    }
    else if (ICOType == uint8(BrightCoinICOType.RegS))
    {

        uint256 geoLocation1;
        uint256 geoLocation2;
  
        //check Accridition Status of Both the Investor as
          Investoevalidity = CheckAccreditionStatus(investor);
          if(Investoevalidity == true) 
               geoLocation1 = GetGeoLocationAccreditedInvestor(investor);
           else
           geoLocation1 = GetGeoLocationOfNonInvestor(investor);

           //check of other Investor
           Investoevalidity = CheckAccreditionStatus(InvestorAddress);
          if(Investoevalidity == true) 
               geoLocation2 = GetGeoLocationAccreditedInvestor(InvestorAddress);
           else
           geoLocation2 = GetGeoLocationOfNonInvestor(InvestorAddress);

           if( geoLocation1 !=1 && geoLocation2 != 1 )  //Make sure GeoLocation ius not USA
              validityStatus =  true;   
     
      return validityStatus;

    }
    else if (ICOType == uint8(BrightCoinICOType.RegDRegS))
    {

        bool validityStatus1 = false;
        bool validityStatus2 = false;
        uint256 geolocation;
        
        Investoevalidity = CheckAccreditionStatus(investor);
          if(Investoevalidity == false) 
          {
               geolocation = GetGeoLocationOfNonInvestor(investor);
               if(geolocation != 1)
                 validityStatus1 =  true; 
          }
          else
          {
             validityStatus1 =  true; 
          }

          bool Investorevalidity2 = CheckAccreditionStatus(InvestorAddress);
          if(Investorevalidity2 == false) 
          {
               geolocation = GetGeoLocationOfNonInvestor(InvestorAddress);
               if( geolocation != 1)
                 validityStatus2 =  true; 
          }
          else
          {
             validityStatus2 =  true; 
          }

          if( (validityStatus1 == true) && (validityStatus2 == true))
          return true;
          else
          return false;
       
    }
    else  //Utility ICO 
    {


         geoLocation1 = GetGeoLocationOfNonInvestor(InvestorAddress);
         geoLocation2 = GetGeoLocationOfNonInvestor(investor);

        if((geoLocation1 != 1) && (geoLocation2 != 1))
              return true;

          return validityStatus;
    }


   return validityStatus;

 }


function checkInvestorValidity( address InvestorAddress, uint8 ICOType)  public view returns(bool)
 {

    bool validityStatus = false;
    uint256 GeoLocation;
 
    if(ICOType == uint8(BrightCoinICOType.RegD))
    {
      validityStatus = CheckAccreditionStatus(InvestorAddress);
       return validityStatus;
    }
    else if (ICOType == uint8(BrightCoinICOType.RegS))
    {
   
      //check if Investor is Accrideted One
      bool AccreditionStatus  = CheckAccreditionStatus(InvestorAddress);
      if(AccreditionStatus == true)
      {
          // now check GeoLocatiom
          uint256 geoLocation = GetGeoLocationAccreditedInvestor(InvestorAddress);
          if(geoLocation != 1) // If Not USA then return true;
            validityStatus = true;

          return validityStatus;
      }    

      GeoLocation = GetGeoLocationOfNonInvestor(InvestorAddress);
      if(GeoLocation != 1) //Should not be USA
      validityStatus = true;
      return validityStatus;

    }
    else if(ICOType == uint8(BrightCoinICOType.RegDRegS))
    {
        //Do check for RegD and RegS stuff
        validityStatus = CheckAccreditionStatus(InvestorAddress);
        if(validityStatus == false)
        {            
           
           GeoLocation = GetGeoLocationOfNonInvestor(InvestorAddress);
           require(GeoLocation !=0, "Geolocation Should not be zero");
           if(GeoLocation != 1) //Should not be USA  
               validityStatus = true;
         
           return validityStatus;
        }
        return validityStatus;

    }
    else  //Utility ICO 
    {
        GeoLocation = GetGeoLocationOfNonInvestor(InvestorAddress);
        if(GeoLocation != 1)
           validityStatus = true;

          return validityStatus;

     }


   return true;

 }


  
}


