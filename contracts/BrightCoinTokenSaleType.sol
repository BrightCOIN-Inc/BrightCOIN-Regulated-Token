pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";

//Section1
//...............................................................................
contract TokenPreSaleDetails is BrightCoinTokenOwner
{

    //address owner;
    using SafeMath for uint;

    constructor() public
    {
    }

  
   //For Presales Only 
    uint256  public constant maxCoinSoldDuringPresale = 5000;
    uint256  public constant BonusAmountPreSale = 0;
    uint8    public constant Discount = 40; 


    //PreSale Start & End Dates 
    uint256 internal ICOstartDate = 1536061800;    
    uint256 internal ICOendDate = 1566102022;     //22/12/2018

    //Current Presale Status 
    bool public PreSaleOn = true;
 
     //Function for changing the startDate of Presale
    function changeStartDate(uint256 startDateTimeStamp) onlyTokenOwner public returns(bool){

    require(ICOstartDate > now);
    require( startDateTimeStamp < ICOendDate );
    ICOstartDate = startDateTimeStamp;
    return true;
  }

    function getMaxCoinSoldDuringPreSale(uint256 decimal) internal returns(uint256)
    {
        uint256 val = maxCoinSoldDuringPresale*(10**uint256(decimal));
        return val;
        
    }

    /**
   * @dev It changes end date of Presale , provided it is not crossed.
   * @param endDateTimeStamp The new proposed end datetime for Presale.
   */
    function changeEndDate(uint256 endDateTimeStamp) onlyTokenOwner public returns(bool) 
    {
      require(ICOendDate > now);
      require( endDateTimeStamp > ICOstartDate );
      ICOendDate = endDateTimeStamp;
      return true;
    }
    
    /**
   * @dev It check whether the datetime passed is in presale period or not
   * @param currenttime The datetime to be checked for presale period.
   */
     function inPreSalePeriod(uint256 currenttime) public view returns (bool) {
      if (currenttime >= ICOstartDate && currenttime < ICOendDate) 
          return true;
      else 
          return false;     
     }

    /**
   * @dev It will change the presale status or true/false depending upon input
   * @param presalestatus the staus to be set with presale.
   */
     function changePresaleStatus(bool presalestatus) onlyTokenOwner public
     {
       PreSaleOn = presalestatus;
     }
}

//Section2
//..........................................................................
contract TokenMainSaleDetails  is BrightCoinTokenOwner
{
   //For MainSale
struct MainSaleTokenDistrubution
{
    uint256 mainStartDate;
    uint256 mainSaleEndDate ;
    uint256 maxCoinSold;
    uint256 discount;
    bool    periodActive;
    uint8   periodIndex;
}

 //address owner;
  using SafeMath for uint;
constructor() public
{
 
}

mapping(uint256 => MainSaleTokenDistrubution) MainSaleCountMapping;
uint8[] internal  mainSaleToken;
uint256 public  CurrentMainSalePeriod = 1;

 /**
   * @dev It add mainsale period details 
   * @param mainStartDate Start date of curent mainsale period
   * @param mainSaleEndDate End Date of MainSale
   * @param MaxCoinSold Maximum coin sold during this period
   * @param discount Bonus if any for this sale period
   * @param PeriodIndex Period Index so that MainSale period can be tracked.
   * @param PeriodActive  Setting current period state.
   */
function AddMainSalePeriod(uint256 mainStartDate,uint256 mainSaleEndDate,uint256 MaxCoinSold,
                        uint256 discount,uint8 PeriodIndex,
                         bool PeriodActive) onlyTokenOwner public   returns(bool)
   {

      MainSaleTokenDistrubution storage mainSale = MainSaleCountMapping[PeriodIndex];
      mainSale.mainStartDate  = mainStartDate;
      mainSale.mainSaleEndDate = mainSaleEndDate;
      mainSale.maxCoinSold = MaxCoinSold;
      mainSale.discount = discount;
      mainSale.periodIndex = PeriodIndex; 
      mainSale.periodActive = PeriodActive;

      mainSaleToken.push(PeriodIndex);
      return true;
    }                                                      
                            

   /**
   * @dev It check whenther current datetime fits is given mainsale period
   * @param DateTimeStamp to be verified.
   * @param PeriodIndex mainSale period Index
   */
 function CheckTokenPeriodSale(uint256 DateTimeStamp, uint8 PeriodIndex) onlyTokenOwner public view returns(bool) {

        MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
       require(MainSaleTokenSale.mainStartDate !=0);
        require(MainSaleTokenSale.mainSaleEndDate !=0);

        if( (MainSaleTokenSale.mainStartDate < DateTimeStamp) && (MainSaleTokenSale.mainSaleEndDate > DateTimeStamp) )
        return true;

        return false;
        
  }

  /**
   * @dev It check bonus details for given mainSale Period 
   * @param PeriodIndex period to be verfied.
   */
 function getMainSaleDiscount(uint8 PeriodIndex) onlyTokenOwner public view returns(uint256) {

        MainSaleTokenDistrubution storage MainSaleToken = MainSaleCountMapping[PeriodIndex];
        return MainSaleToken.discount;
  }

   /**
   * @dev It ends mainSale for s given period 
   * @param PeriodIndex period to be End.
   */
  function EndMainSale(uint8 PeriodIndex) onlyTokenOwner public
  {

  MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
  MainSaleTokenSale.periodActive = false;

  //Whether we need to give refund instantly  , to be managed by Application not Samrt contract

  }

  /**
   * @dev Check if mainSale is On  for a particular period
   * @param PeriodIndex period to be verfied.
   */
 function CheckIfMainSaleOn(uint8 PeriodIndex)  public view returns(bool) {

        MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
        return(MainSaleTokenSale.periodActive);
        
  }


 /**
   * @dev It returns total mainSale count
   */
  function MainSaleCount() view public returns(uint256)
  {
     return mainSaleToken.length;
  }

  /**
   * @dev Check limit of main sale for a particular 
   * @param periodIndex period to be verfied.
   * @param  tokenamount to be compared with maximit
   * @param  decimalValue this value to multipled with value so that compare uint become same
   */
  function CheckMainSaleLimit( uint8 periodIndex, uint256 tokenamount,uint256 decimalValue) view public returns(bool)
  {

    MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[periodIndex];

    uint256 maxCoinSoldDecimal = (MainSaleTokenSale.maxCoinSold).mul(10**uint256(decimalValue));
    if(tokenamount <= maxCoinSoldDecimal )
      return true;

      return false;

  }

/**
   * @dev it changes the limit of max token that can be sold in this period
   * @param periodIndex period to be verfied.
   */
  function changeMainSaleLimit( uint8 periodIndex, uint256 maxTokenTobeSold)  onlyTokenOwner public 
  {

  MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[periodIndex];
  MainSaleTokenSale.maxCoinSold = maxTokenTobeSold;

  }

  /**
   * @dev it changes the limit of max token that can be sold in this period
   * @param currenttime check current time for mainSale
   */
  function checkMainSalePeriod( uint256 currenttime)  internal returns(uint8)
  {

  if(mainSaleToken.length  == 0)
    return 0;
  //get first MainSale period Index
  uint256 periodindex;
  for(periodindex = 0; periodindex <=mainSaleToken.length; periodindex++)
  {
  MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[periodindex];
  if( (MainSaleTokenSale.mainStartDate <= currenttime) && 
                      (currenttime <=MainSaleTokenSale.mainSaleEndDate) )
  {
       return MainSaleTokenSale.periodIndex;
  }
  return 0;

  }

  }

}
    

 
  