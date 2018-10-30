pragma solidity ^0.4.24;
import "./BrightCoinTokenOwner.sol";
import "./SafeMath.sol";
import "./BrightCoinTokenConfig.sol";

//Section1
//...............................................................................
contract TokenPreSaleDetails is BrightCoinTokenOwner, BrightCoinTokenConfig
{

    //address owner;
    using SafeMath for uint;
    constructor() public
    {
    }

  
    //Current Presale Status 
    bool public PreSaleOn = true;
 
     //Function for changing the startDate of Presale
    function changeStartDate(uint256 _startDateTimeStamp) public onlyTokenOwner  returns(bool){

    require(ICOstartDate > now);
    require( _startDateTimeStamp < ICOendDate );
    ICOstartDate = _startDateTimeStamp;
    return true;
  }

    function getMaxCoinSoldDuringPreSale(uint256 _decimal) pure internal  returns(uint256)
    {
        uint256 val = maxCoinSoldDuringPresale*(10**uint256(_decimal));
        return val;
        
    }

    /**
   * @dev It changes end date of Presale , provided it is not crossed.
   * @param _endDateTimeStamp The new proposed end datetime for Presale.
   */
    function changeEndDate(uint256 _endDateTimeStamp) public onlyTokenOwner  returns(bool) 
    {
      require(ICOendDate > now);
      require( _endDateTimeStamp > ICOstartDate );
      ICOendDate = _endDateTimeStamp;
      return true;
    }
    
    /**
   * @dev It check whether the datetime passed is in presale period or not
   * @param _currenttime The datetime to be checked for presale period.
   */
     function inPreSalePeriod(uint256 _currenttime) public view returns (bool) {
      if (_currenttime >= ICOstartDate && _currenttime < ICOendDate) 
          return true;
      else 
          return false;     
     }

    /**
   * @dev It will change the presale status or true/false depending upon input
   * @param _presalestatus the staus to be set with presale.
   */
     function changePresaleStatus(bool _presalestatus) public onlyTokenOwner 
     {
       PreSaleOn = _presalestatus;
     }
}

//Section2
//..........................................................................
contract TokenMainSaleDetails  is BrightCoinTokenOwner
{
   //For MainSale
struct mainSaleTokenDistrubution
{
    uint256 mainStartDate;
    uint256 mainSaleEndDate ;
    uint256 maxCoinSold;
    uint256 discount;
    bool    periodActive;
    uint8  periodIndex;
    bool exists;
}

 //address owner;
  using SafeMath for uint;
  
constructor() public
{
 
}

mapping(uint256 => mainSaleTokenDistrubution) mainSaleCountMapping;
uint256[] internal  mainSaleToken;

 /**
   * @dev It add mainsale period details 
   * @param _mainStartDate Start date of curent mainsale period
   * @param _mainSaleEndDate End Date of MainSale
   * @param _maxCoinSold Maximum coin sold during this period
   * @param _discount Bonus if any for this sale period
   * @param _periodIndex Period Index so that MainSale period can be tracked.
   * @param _periodActive  Setting current period state.
   */
function AddMainSalePeriod(uint256 _mainStartDate,uint256 _mainSaleEndDate,uint256 _maxCoinSold,
                        uint256 _discount,uint8 _periodIndex,
                         bool _periodActive) public onlyTokenOwner  returns(bool)
   {

      mainSaleTokenDistrubution storage mainSale = mainSaleCountMapping[_periodIndex];
      require(mainSale.exists == false); //To ensure that it is  new instance
      
      mainSale.mainStartDate  = _mainStartDate;
      mainSale.mainSaleEndDate = _mainSaleEndDate;
      mainSale.maxCoinSold = _maxCoinSold;
      mainSale.discount = _discount;
      mainSale.periodIndex = _periodIndex; 
      mainSale.periodActive = _periodActive;
      mainSale.exists = true;

      mainSaleToken.push(_periodIndex);
      return true;
    }                                                      
                            

   /**
   * @dev It check whenther current datetime fits is given mainsale period
   * @param _dateTimeStamp to be verified.
   * @param _periodIndex mainSale period Index
   */
 function CheckTokenPeriodSale(uint256 _dateTimeStamp, uint8 _periodIndex) public onlyTokenOwner  view returns(bool) {

        mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[_periodIndex];
       require(mainSaleTokenSale.mainStartDate !=0);
        require(mainSaleTokenSale.mainSaleEndDate !=0);

        if( (mainSaleTokenSale.mainStartDate < _dateTimeStamp) && (mainSaleTokenSale.mainSaleEndDate > _dateTimeStamp) )
        return true;

        return false;
        
  }

  /**
   * @dev It check bonus details for given mainSale Period 
   * @param _periodIndex period to be verfied.
   */
 function getMainSaleDiscount(uint8 _periodIndex)  internal view returns(uint256) {

        mainSaleTokenDistrubution storage mainSaleToken = mainSaleCountMapping[_periodIndex];
        return mainSaleToken.discount;
  }

   /**
   * @dev It ends mainSale for s given period 
   * @param _periodIndex period to be End.
   */
  function EndMainSale(uint8 _periodIndex) public onlyTokenOwner 
  {

  mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[_periodIndex];
  mainSaleTokenSale.periodActive = false;

  //Whether we need to give refund instantly  , to be managed by Application not Samrt contract

  }

  /**
   * @dev Check if mainSale is On  for a particular period
   * @param _periodIndex period to be verfied.
   */
 function CheckIfMainSaleOn(uint8 _periodIndex)  public view returns(bool) {

        mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[_periodIndex];
        return(mainSaleTokenSale.periodActive);
        
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
   * @param _periodIndex period to be verfied.
   * @param  _tokenamount to be compared with maximit
   * @param  _decimalValue this value to multipled with value so that compare uint become same
   */
  function CheckMainSaleLimit( uint8 _periodIndex, uint256 _tokenamount,uint256 _decimalValue) view public returns(bool)
  {

    mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[_periodIndex];

    uint256 maxCoinSoldDecimal = (mainSaleTokenSale.maxCoinSold).mul(10**uint256(_decimalValue));
    if(_tokenamount <= maxCoinSoldDecimal )
      return true;

      return false;

  }

/**
   * @dev it changes the limit of max token that can be sold in this period
   * @param _periodIndex period to be verfied.
   * @param _maxTokenTobeSold  maximum token to be sold
   */
  function changeMainSaleLimit( uint8 _periodIndex, uint256 _maxTokenTobeSold) public onlyTokenOwner  
  {

  mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[_periodIndex];
  mainSaleTokenSale.maxCoinSold = _maxTokenTobeSold;

  }

  /**
   * @dev it changes the limit of max token that can be sold in this period
   * @param _currenttime check current time for mainSale
   */
  function checkMainSalePeriod( uint256 _currenttime) view internal returns(uint256)
  {

  if(mainSaleToken.length  == 0)
    return 0;
  //get first MainSale period Index
  uint8 periodindex;
  for(periodindex = 0; periodindex <=mainSaleToken.length; periodindex++)
  {
  mainSaleTokenDistrubution storage mainSaleTokenSale = mainSaleCountMapping[periodindex];
  if( (mainSaleTokenSale.mainStartDate <= _currenttime) && 
                      (_currenttime <=mainSaleTokenSale.mainSaleEndDate) )
  {
       return mainSaleTokenSale.periodIndex;
  }

  }
  
  return 0;

  }

}
    

 
  