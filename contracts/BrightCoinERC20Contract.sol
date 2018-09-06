pragma solidity ^0.4.24;
//pragma experimental "v0.5.0";

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinERC20ContractInterface.sol";
import "./BrightCoinTokenSaleType.sol";
import "./BrightCoinTokenDistributionDetails.sol";
import "./SafeMath.sol";


contract BrightCoinERC20 is BrightCoinTokenOwner,TokenPreSaleDetails(msg.sender),TokenMainSaleDetails(msg.sender) ,BrightCoinTokenDistributionDetails(msg.sender)
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
  string public constant Tokensymbol = "ABC"; // This is token symbol
  string public constant TokenName = "TokenName"; // this is token name
  uint256 public constant decimals = 18; // decimal digit for token price calculation
  string public constant version = "1.0";
  uint8 public constant ICOType = 1;   //0 for RegD , 1 for RegS and 2 for RedD & RegS and 3x means utility ICO
  bool  internal isICOActive = true; 
  
  enum BrightCoinICOType { RegD, RegS, RegDRegS, Utility }

//Token Supply Details
  uint256 public constant initialSupply = 100000;
  uint256 public totalSupply; //Need to set at constructor level
  uint256 private  BountyDistriuted = 0;
  

  //Purchase Rate
  //purchase rate can be changed by the Owner
  uint256 public purchaseRate = 1000;
  function setPurchaseRate(uint newRate) public onlyTokenOwner(owner) {
        require(purchaseRate != newRate);
        purchaseRate = newRate;
    }
 
 //ICO SoftCap & HardCap
 /*
    Soft cap is the minimal amount required by your project, to make it viable, in order to continue. If you do not reach that amount during your ICO then you should allow your investors to refund their money using a push/ pull mechanism.
 */
  uint internal ICOSoftCap = 1000000; //Minimum Eather to Reach
  //uint internal ICOHardCap = 7*(10**6)*(10**uint256(decimals));  //Maximum Ether to Reach
  uint internal ICOHardCap = 20000;


  function ChangeSoftCap(uint newSoftCap) public onlyTokenOwner(owner) {
        require(ICOSoftCap != newSoftCap);
        require(newSoftCap < totalSupply);
        ICOSoftCap = newSoftCap;
      
    }
    function ChangeHardCap(uint newHardCap) public onlyTokenOwner(owner) {
        require(ICOHardCap != newHardCap);
        require(newHardCap < totalSupply);
        ICOHardCap = newHardCap;
      
    }

    function GetSoftCap() onlyTokenOwner(owner) view public  returns(uint256) {

      return ICOSoftCap;
    }

     function GetHardCap()  onlyTokenOwner(owner) view public returns(uint256) {

      return ICOHardCap;
    }

    //Check if softcap reached
    function CheckIfSoftCapReached() onlyTokenOwner(owner)   internal  view returns(bool)
    {

      uint tokenSold = totalSupply.sub(balances[owner]);

        if(tokenSold > ICOSoftCap)
          return true;
          else 
          return false;  
        
    }

    //check if HARD Cap Achived
    function CheckIfHardcapAchived(uint256 tokens)  internal view returns(bool)
    {
      uint tokenSold = totalSupply.sub(balances[owner]);
      require(tokenSold <= ICOHardCap);
      require(tokenSold.add(tokens) <=ICOHardCap);
      return true;

    }
 
    
  
  //Investment storage address
  address public FundDepositAddress = 0x403f4fedf6127f30e77ae8295dea47eea0832899; //Should be taken from Script 
  function ChangeFundDepositAddress(address NewFundDepositAddress) onlyTokenOwner(owner) public {
    require( FundDepositAddress != NewFundDepositAddress );
    FundDepositAddress = NewFundDepositAddress;
  }
  

//option for Minting more token 
bool public MintMoreTokens  = false;
function UpdateTokenMintingOption(bool mintingOption) onlyTokenOwner(owner) public {
  
  MintMoreTokens = mintingOption;
}


 /////////////////////////////////////////////////   

 
 ////////////////////////////////////////
  mapping(address => uint256) balances;
 //////////////////////////////////////////
  
 
  constructor () public{

   totalSupply = initialSupply*(10**uint256(decimals));

   TotalAllocatedTeamToken = InitialAllocatedTeamToken*(10**uint256(decimals));
   FounderToken = InitialFounderToken*(10**uint256(decimals));
   RewardsBountyToken = InitialRewardsBountyToken*(10**uint256(decimals));
   CompanyHoldingValue = InitialCompanyHoldingValue*(10**uint256(decimals));
   TotalAllocatedAdvisorToken = InitialAllocatedAdvisorToken*(10**uint256(decimals));
   ICOHardCap = ICOHardCap*(10**uint256(decimals));

    balances[msg.sender] = totalSupply;
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
    function mint(address _to, uint _value) onlyTokenOwner(owner) public {
        require(msg.sender == owner); // assuming you have a contract owner
        mintToken(_to, _value);
    }

    /// @notice Will allow multiple minting within a single call to save gas.
    /// @param recipients A list of addresses to mint for.
    /// @param _values The list of values for each respective `_to` address.
    function airdropMinting(address[] recipients, uint256[] _values) onlyTokenOwner(owner) public {
        require(msg.sender == owner); // assuming you have a contract owner
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
   function burn(uint256 _value) onlyTokenOwner(owner) public {
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
   function StopICO(bool _status) onlyTokenOwner(owner) public {

    isICOActive = _status;
   }
  

}