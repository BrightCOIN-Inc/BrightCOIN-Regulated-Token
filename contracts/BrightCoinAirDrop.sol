pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinRegulatedToken.sol";
import "./SafeMath.sol";

contract BrightCoinAirDrop  is BrightCoinTokenOwner
{
    BrightCoinRegulatedToken RegulatedERC20Token;
    using SafeMath for uint;
    bool private  ContractValue = false;
 
    function SetRegulatedTokenContract(address _regulatedtoken) public  onlyTokenOwner 
    {
         RegulatedERC20Token = BrightCoinRegulatedToken(_regulatedtoken);
         ContractValue = true;
    } 

     function GetBountyTokenBalances() public onlyTokenOwner view  returns(uint256)
     {
        return  RegulatedERC20Token.balanceOf(msg.sender);
     }
     
    function TransferBounties( address _bountyhunter, uint256 _amount,uint256 _lockexpiry, 
                                    bool _lockApplied) public onlyTokenOwner 
    {
        require(ContractValue == true, "Regulated token not set");
       // require(addr != 0x0);
        require(_amount >0);
        require(_lockexpiry >=0);
       uint256 locktime  =  now.add(_lockexpiry);
        require(_amount <=RegulatedERC20Token.balanceOf(msg.sender));
        RegulatedERC20Token.TransferBountyToken(msg.sender , _bountyhunter,_amount, locktime, _lockApplied);
                  
        //user Regulated token instance and call method inside method it will check if that no of token in minted or not if not it will throw error
        //that method must have transfer the token to respective address without locking it anywhere
    }
    
}