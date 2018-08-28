pragma solidity ^0.4.23;

contract BrightCoinTokenOwner
{
    address owner;

    constructor () internal
    {
        owner = msg.sender;
    }

    modifier onlyTokenOwner(address _account) {
        require(msg.sender == _account, "Owner Not Authorized");
        _;
    }

    /*function changeOwner(address _newOwner) onlyTokenOwner() {

    newOwner = _newOwner;

}

function acceptOwnership() {
    if (msg.sender == newOwner) {
        owner = newOwner;
        newOwner = 0x0000000000000000000000000000000000000000;
    }

}
*/
}