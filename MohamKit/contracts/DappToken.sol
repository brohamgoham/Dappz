pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DappToken is ERC20 {
    constructor() public ERC20("Dapp", "DAPP") {
        _mint(msg.sender, 1000000000000000000);
    }
}