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
    uint256  public constant maxCoinSoldDuringPresale = 1000*100;
    uint256  public constant BonusAmountPreSale = 0;
    uint8    public constant Discount = 0; 

    //Presale Maximum and Minmum Contributions
    uint256  internal MinimumContributionPreSale = 0.5 ether;
    uint256  internal MaximumContributionPreSale  = 30 ether;

    //PreSale Start & End Dates 
    uint256 internal ICOstartDate = 1536061800;    
    uint256 internal ICOendDate = 1566102022;     //22/12/2018
 
     //Function for changing the startDate of Presale
    function changeStartDate(uint256 startDateTimeStamp) onlyTokenOwner public returns(bool){

    require(ICOstartDate > now);
    require( startDateTimeStamp < ICOendDate );
    ICOstartDate = startDateTimeStamp;
    return true;
  }

    //Function for changing the endDate of Presale
    function changeEndDate(uint256 endDateTimeStamp) onlyTokenOwner public returns(bool) 
    {
      require(ICOendDate > now);
      require( endDateTimeStamp > ICOstartDate );
      ICOendDate = endDateTimeStamp;
      return true;
    }
    
     //  Function for validating the pre sale period
     function inPreSalePeriod(uint256 currenttime) public view returns (bool) {
      if (currenttime >= ICOstartDate && currenttime < ICOendDate) 
          return true;
      else 
          return false;     
     }

     //Check if presale is ON
     bool public PreSaleOn = true; 
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
    uint256 MaxCoinSold;
    uint256 BonusDuringMainsale;
    uint256 TokenLockinPeriod;
    bool    PeriodActive;
    uint8 PeriodIndex;
}

 //address owner;
constructor() public
{
 
}

mapping(uint256 => MainSaleTokenDistrubution) MainSaleCountMapping;
uint8[] internal  mainSaleToken;

function AddMainSalePeriod(uint256 mainStartDate,uint256 mainSaleEndDate,uint256 TokenLockinPeriod,uint256 MaxCoinSold,uint256 BonusDuringMainsale,uint8 PeriodIndex, bool PeriodActive) onlyTokenOwner public   returns(bool)
   {

      MainSaleTokenDistrubution storage mainSale = MainSaleCountMapping[PeriodIndex];
      mainSale.mainStartDate  = mainStartDate;
      mainSale.mainSaleEndDate = mainSaleEndDate;
      mainSale.TokenLockinPeriod = TokenLockinPeriod;
      mainSale.MaxCoinSold = MaxCoinSold;
      mainSale.BonusDuringMainsale = BonusDuringMainsale;
      mainSale.PeriodIndex = PeriodIndex; 
      mainSale.PeriodActive = PeriodActive;

      mainSaleToken.push(PeriodIndex);
      return true;
    }                                                      
                            

                            

  //Function for changing the startDate of ICO
 function CheckTokenPeriodSale(uint256 DateTimeStamp, uint8 PeriodIndex) onlyTokenOwner public view returns(bool) {

        MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
       require(MainSaleTokenSale.mainStartDate !=0);
        require(MainSaleTokenSale.mainSaleEndDate !=0);

        if( (MainSaleTokenSale.mainStartDate < DateTimeStamp) && (MainSaleTokenSale.mainSaleEndDate > DateTimeStamp) )
        return true;

        return false;
        
  }

  //Function for getting bonus details
 function GetBonusDetails(uint8 PeriodIndex) onlyTokenOwner public view returns(uint256) {

        MainSaleTokenDistrubution storage MainSaleToken = MainSaleCountMapping[PeriodIndex];
        return MainSaleToken.BonusDuringMainsale;
        
  }

  //EndToken Mail Sale Abruptly
  function EndMainSale(uint8 PeriodIndex) onlyTokenOwner public
  {

  MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
  MainSaleTokenSale.PeriodActive = false;

  //Whether we need to give refund instantly  , to be managed by Application not Samrt contract

  }

  //Function for changing the startDate of ICO
 function CheckIfMainSaleOn(uint8 PeriodIndex)  public view returns(bool) {

        MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[PeriodIndex];
        return(MainSaleTokenSale.PeriodActive);
        
  }


  function MainSaleCount() view public returns(uint256)
  {
     return mainSaleToken.length;
  }

  function CheckMainSaleLimit( uint8 periodIndex, uint256 tokenamount) view public returns(bool)
  {

    MainSaleTokenDistrubution storage MainSaleTokenSale = MainSaleCountMapping[periodIndex];
    if(tokenamount <= MainSaleTokenSale.MaxCoinSold )
      return true;

      return false;

  }


}
    

 
  