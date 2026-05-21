// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BabyBlank is ERC20 {

    string public _name = "Baby Blank";
    string public _symbol = "BBB";
    uint256 private _totalSupply;

    address private owner;

    constructor() ERC20(_name, _symbol){
        owner = _msgSender();
        _totalSupply = (10 ** 12) * (10 ** 18);
        _mint(owner, _totalSupply);
        emit Transfer(address(0), owner, _totalSupply);
    }

}