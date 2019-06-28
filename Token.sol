pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract SNFCoin is ERC20, ERC20Detailed {

    string private _name = "SANFRE";
    string private _symbol = "SNF";
    uint8 private _decimals = 18;

    address account = msg.sender;
    uint value = 100000000000000000000000000;

    constructor() ERC20Detailed( _name, _symbol, _decimals) public {
        _mint(account, value);
    }
}
