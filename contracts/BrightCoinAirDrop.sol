pragma solidity ^0.4.24;

import "./BrightCoinTokenOwner.sol";
import "./BrightCoinRegulatedToken.sol";
import "./SafeMath.sol";

contract BrightCoinAirDrop  is BrightCoinTokenOwner
{
    BrightCoinRegulatedToken RegulatedERC20Token;
    using SafeMath for uint;
    bool private  ContractValue = false;
    //Before that ERC20 contract must have mint that kuch coin and tranfer it to prescribed address

    function SetRegulatedTokenContract(address _regulatedtoken) onlyTokenOwner public
    {
         RegulatedERC20Token = BrightCoinRegulatedToken(_regulatedtoken);
         ContractValue = true;
    } 


    function TransferBounties(address addr, uint amount,uint256 lockexpiry, 
                                    bool lockApplied) onlyTokenOwner public
    {
        require(ContractValue == true, "Regulated token not set");

        uint256 locktime  =  now.add(lockexpiry);
        RegulatedERC20Token.TransferBountyToken(addr,amount, locktime,lockApplied);

        //user Regulated token instance and call method inside method it will check if that no of token in minted or not if not it will throw error
        //that method must have transfer the token to respective address without locking it anywhere
    }
    
}