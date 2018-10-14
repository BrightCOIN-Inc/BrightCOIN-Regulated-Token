pragma solidity ^0.4.24;
//pragma experimental "v0.5.0";

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinERC20ContractInterface.sol";
import "./BrightCoinTokenSaleType.sol";
import "./BrightCoinAdminTokenDistributionDetails.sol";
import "./SafeMath.sol";
import "./BrightCoinInvestorTokenLock.sol";




contract BrightCoinERC20 is TokenPreSaleDetails,
                            TokenMainSaleDetails,
                           BrightCoinAdminTokenDistributionDetails,
                            BrightCoinInvestorTokenLock
                           
                          
                         
                            
{
  using SafeMath for uint;


 event Transfer(address indexed from, address indexed _to, uint256 _value);
  event Approval(address indexed owner, address indexed _spender, uint256 _value);
   // Event called when presale is done
  event PresaleFinalized(uint tokens);
  event ICOSoftCapReached(string softcap);
  event ICOSoftUnsuccessFull(uint256 TokenSold,string str);
  event Burn(address addr, uint256 tokens);
  event Mint(address target, uint256 mintedAmount);
  
 //Token Details  
  string public constant symbol = "XBR"; // This is token symbol
  string public constant name = "BrightCOIN"; // this is token name
  uint256 public constant decimals = 18; // decimal digit for token price calculation
  string public constant version = "1.0";
  uint8 public constant ICOType = 2;   //0 for RegD , 1 for RegS and 2 for RedDRegS and 3 means utility ICO
  bool  internal pauseICO = false; 
  
  enum BrightCoinICOType { RegD, RegS, RegDRegS, Utility }

//Token Supply Details
  uint256 public constant initialSupply = 30000;
  uint256 public totalSupply; //Need to set at constructor level
  uint256 private  BountyDistriuted = 0;
  
  //Presale Maximum and Minmum Contributions
    uint256  internal MinimumContribution = 0.05 ether;
    uint256  internal MaximumContribution = 0.3 ether;

  //Purchase Rate
  //purchase rate can be changed by the Owner
  uint256 public purchaseRate = 5000;  //5000 token per Ether
  function setPurchaseRate(uint newRate) public onlyTokenOwner {
        require(purchaseRate != newRate);
        purchaseRate = newRate;
    }
 
 //ICO SoftCap & HardCap
 /*
    Soft cap is the minimal amount required by your project, to make it viable, in order to continue. If you do not reach that amount during your ICO then you should allow your investors to refund their money using a push/ pull mechanism.
 */
  uint internal ICOSoftlimit = 5000; //Minimum Eather to Reach
  uint internal ICOHardlimit = 30000;


  function ChangeSoftCap(uint newSoflimit) public onlyTokenOwner {
        require(ICOSoftlimit != newSoflimit);
        require(newSoflimit < totalSupply);
        ICOSoftlimit = newSoflimit;
      
    }
    function ChangeHardLimtit(uint256 newHardlimit) public onlyTokenOwner {
       
        require(ICOHardlimit != newHardlimit);
        require(newHardlimit < totalSupply);
        ICOHardlimit = newHardlimit;
      
    }

    function GetSoftLimit() onlyTokenOwner view public  returns(uint256) {

      return ICOSoftlimit;
    }

     function GetHardLimit()  onlyTokenOwner view public returns(uint256) {

      return ICOHardlimit;
    }

    //Check if softcap reached
    function CheckIfSoftlimitReached() onlyTokenOwner   internal  view returns(bool)
    {

      uint tokenSold = totalSupply.sub(balances[owner()]);

        if(tokenSold > ICOSoftlimit)
          return true;
          else 
          return false;  
        
    }

    //check if HARD Cap Achived
    function CheckIfHardlimitAchived(uint256 tokens)  internal view returns(bool)
    {
      uint tokenSold = totalSupply.sub(balances[owner()]);
      require(tokenSold <= ICOHardlimit);
      require(tokenSold.add(tokens) <=ICOHardlimit);
      return true;

    }
 
    
  
  //Investment storage address
  address public FundDepositAddress = 0x715f24e3e143cb839E8A6b167EF0A5934CCB61d6; //Should be taken from Script 
  function ChangeFundDepositAddress(address NewFundDepositAddress) onlyTokenOwner public {
    require( FundDepositAddress != NewFundDepositAddress );
    FundDepositAddress = NewFundDepositAddress;
  }
  

//option for Minting more token 
bool public MintMoreTokens  = false;
function UpdateTokenMintingOption(bool mintingOption) onlyTokenOwner public {
  
  MintMoreTokens = mintingOption;
}


 /////////////////////////////////////////////////   

 
 ////////////////////////////////////////
  mapping(address => uint256) balances;

 //////////////////////////////////////////
  
 
  constructor () public{

   totalSupply = initialSupply*(10**uint256(decimals));

  TotalAllocatedTeamToken = InitialAllocatedTeamToken*(10**uint256(decimals));
 TotalAllocatedFounder = InitialFounderToken*(10**uint256(decimals));
   TotalAllocatedAdvisorToken = InitialAllocatedAdvisorToken*(10**uint256(decimals));
   CompanyHoldingValue = InitialCompanyHoldingValue*(10**uint256(decimals));
   BountyAllocated = totalBountyAllocated*(10**uint256(decimals));
   

   ICOHardlimit = ICOHardlimit.mul(10**uint256(decimals));
   ICOSoftlimit = ICOSoftlimit.mul(10**uint256(decimals));
   
   balances[msg.sender] = totalSupply;
   
  FounderBalances[msg.sender] = TotalAllocatedFounder;
  AdvisorBalances[msg.sender] = TotalAllocatedAdvisorToken;
  TeamBalances[msg.sender] = TotalAllocatedTeamToken;
  CompanyHoldingBalances[msg.sender] = CompanyHoldingValue;
  BountyBalances[msg.sender]  = BountyAllocated;
   
  
   BountyDistriuted = 0;
 
  }

 

 // This function returns remaininig token
  function balanceOf(address who) public constant returns (uint256) {
      return balances[who];
  }

//Function Total Supply
function totalSupply() public constant returns (uint256) {
      return totalSupply;
  }

 
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      
        return true;
    }
    

    function approve(address _spender, uint256 _value) public returns (bool success) {
     
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return 1;
      }
    
   
    /// @notice Will Transfer tokens from current address to receipient address.
    /// @param to  addresses to send token.
    /// @param tokens amount of token to be transferred.
    function internaltransfer(address to, uint256 tokens) internal returns (bool) {
  
     // Prevent transfer to 0x0 address. 
    require(to != 0x0);
    require (tokens > 0);
   require (msg.sender != to);
   require(balances[msg.sender] >= tokens);
   require(balances[to] + tokens > balances[to]);
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    emit Transfer(msg.sender, to, tokens);
    
    return true;
   }
   
   

    /// @notice Will cause a certain `_value` of coins minted for `_to`.
    /// @param _to The address that will receive the coin.
    /// @param _value The amount of coin they will receive.
    function mint(address _to, uint _value) onlyTokenOwner public {
       // assuming you have a contract owner
        mintToken(_to, _value);
    }

    /// @notice Will allow multiple minting within a single call to save gas.
    /// @param recipients A list of addresses to mint for.
    /// @param _values The list of values for each respective `_to` address.
    function airdropMinting(address[] recipients, uint256[] _values) onlyTokenOwner public {
        // assuming you have a contract owner
        require(recipients.length == _values.length);
        for (uint i = 0; i < recipients.length; i++) {

            mintToken(recipients[i], _values[i]);
        }
    }

    /// Internal method shared by `mint()` and `airdropMinting()`.
    function mintToken(address _to, uint256 _value) internal {

   
        balances[_to]  = balances[_to].add(_value);
        totalSupply =  totalSupply.add(_value); 
        require(balances[_to] >= _value && totalSupply >= _value); // overflow checks
        emit  Mint(_to, _value);
    } 

    /// @notice it will burn all the token passed as parameter.
    /// @param _value Value of token to be burnt
   function burn(uint256 _value) onlyTokenOwner public {
    require(_value > 0);
    require(_value <= balances[msg.sender]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply = totalSupply.sub(_value);
    emit Burn(burner, _value);
   }


   //Owner of ICO can anytime Stop the ICO post that no any transaction will happen
   function pauseICOtransaction(bool _status) onlyTokenOwner public {

    pauseICO = _status;
   }

//Check if token is available for further Distribution to Admin
 function InterTransferToAdmin(address addr,
                     uint256 TokenAmount,
                     uint8 AdminType )   internal  returns(bool)
 {
     

     if(AdminType == uint8(BrightCoinAdminType.Founder))
    {
        require(TokenAmount <= FounderBalances[msg.sender]);
         balances[addr] = balances[addr].add(TokenAmount);
         FounderBalances[msg.sender] = FounderBalances[msg.sender].sub(TokenAmount);
        // emit Transfer(msg.sender, addr, TokenAmount);
      return true;
    }
    else if (AdminType == uint8(BrightCoinAdminType.Advisor))
    {
      require(TokenAmount <= AdvisorBalances[msg.sender]);
      balances[addr] = balances[addr].add(TokenAmount);
      AdvisorBalances[msg.sender] = AdvisorBalances[msg.sender].sub(TokenAmount);
     // emit Transfer(msg.sender, addr, TokenAmount);
      return true;
    }
    else if(AdminType == uint8(BrightCoinAdminType.Team))
    {
      require(TokenAmount <= TeamBalances[msg.sender]);
      balances[addr] = balances[addr].add(TokenAmount);
      TeamBalances[msg.sender] = TeamBalances[msg.sender].sub(TokenAmount);
     // emit Transfer(msg.sender, addr, TokenAmount);
      return true;

    }  
    
    
 }
    //Check if token is available for further Distribution to Advisor
 function InternalBountyTransfer(address addr, uint256 Tokenamount)  internal returns(bool)
 {
     require(Tokenamount <= BountyBalances[msg.sender]);
     balances[addr] = balances[addr].add(Tokenamount);
     BountyBalances[msg.sender] = BountyBalances[msg.sender].sub(Tokenamount);
    emit Transfer(msg.sender, addr, Tokenamount);
     return true;
 }  
 
}