pragma solidity ^0.4.24;

contract BrightCoinTokenConfig
{

    //Token Details  
  string public constant symbol = "XBR"; // This is token symbol
  string public constant name = "BrightCOIN"; // this is token name
  uint256 public constant decimals = 18; // decimal digit for token price calculation
  string public constant version = "1.0";

  uint256 public constant initialSupply = 30000;

   //For Presales Only 
    uint256  public constant maxCoinSoldDuringPresale = 5000;
    uint256  public constant BonusAmountPreSale = 0;
    uint8    public constant Discount = 40; 

     //PreSale Start & End Dates 
    uint256 internal ICOstartDate = 1539835866; //18/10/2018 04:11AM GMT
    uint256 internal ICOendDate =  1539843066;   //18/10/2018 06:11AM GMT

     //Presale Maximum and Minmum Contributions
    uint256  internal MinimumContribution = 0.05 ether;
    uint256  internal MaximumContribution = 0.3 ether;

    //purchase rate can be changed by the Owner
     uint256 public purchaseRate = 5000;  //5000 token per Ether

    enum BrightCoinICOType { RegD, RegS, RegDRegS, Utility }
    uint8 public constant ICOType = uint8(BrightCoinICOType.RegDRegS);   //0 for RegD , 1 for RegS and 2 for RedDRegS and 3 means utility ICO

   uint256 public constant InitialFounderToken = 20000;
   uint256 internal constant InitialAllocatedTeamToken = 2000;  // Token token allocated for Team distribution
   uint256 internal constant InitialAllocatedAdvisorToken = 5000;


   uint internal icoSoftcap = 5000; //Minimum Eather to Reach
   uint internal icoHardcap = 30000;

    //Investment storage address
  address public FundDepositAddress = 0x347a4442d3325a06b46c8860e168df440c2ad881; //Should be taken from Script 

   //Company Holdings
 address public constant CompanyHoldingAddress = 0xfedf9e65af88f215738e74114cb2c2218076f8b5;
 uint256 public constant InitialCompanyHoldingValue = 40000;// Value to be updated via Script

//Bounty Token Distribution
uint256 public constant totalBountyAllocated = 3000;
address public  constant BountyTokenHolder = 0x30533279DeF53608a38e9147E7B648d16A0A84Fb; //This address own the token and finally transfer



}