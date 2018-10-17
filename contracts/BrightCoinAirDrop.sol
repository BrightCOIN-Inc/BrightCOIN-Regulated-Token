pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinRegulatedToken.sol";
import "./SafeMath.sol";

contract BrightCoinAirDrop  is BrightCoinTokenOwner
{
    BrightCoinRegulatedToken RegulatedERC20Token;
    using SafeMath for uint;
    bool private  ContractValue = false;
 
    function SetRegulatedTokenContract(address _regulatedtoken) onlyTokenOwner public
    {
         RegulatedERC20Token = BrightCoinRegulatedToken(_regulatedtoken);
         ContractValue = true;
    } 

     function GetBountyTokenBalances() onlyTokenOwner view public returns(uint256)
     {
        return  RegulatedERC20Token.balanceOf(msg.sender);
     }
     
    function TransferBounties( address bountyhunter, uint256 amount,uint256 lockexpiry, 
                                    bool lockApplied) onlyTokenOwner public
    {
        require(ContractValue == true, "Regulated token not set");
       // require(addr != 0x0);
        require(amount >0);
        require(lockexpiry >=0);
       uint256 locktime  =  now.add(lockexpiry);
        require(amount <=RegulatedERC20Token.balanceOf(msg.sender));
        RegulatedERC20Token.TransferBountyToken(msg.sender , bountyhunter,amount, locktime, lockApplied);
                  
        //user Regulated token instance and call method inside method it will check if that no of token in minted or not if not it will throw error
        //that method must have transfer the token to respective address without locking it anywhere
    }
    
}