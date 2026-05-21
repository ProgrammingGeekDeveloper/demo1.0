// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Blank.sol";
import "./BabyBlank.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract Bank is Context {
    string public name = "Blank Decentralized Bank";
    address private owner;
    Blank private _Blank;
    BabyBlank private _BabyBlank;

    uint256 private totalValueLocked;
    uint256 private rewardRate = 5;

    constructor(Blank blank_, BabyBlank babyBlank_) {
        _Blank = blank_;
        _BabyBlank = babyBlank_;
        owner = (_msgSender());
    }

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    event StakeToken(address staker, uint256 value);

    function getOwner() public view returns (address) {
        return owner;
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getTotalValueLocked() public view returns (uint256) {
        return totalValueLocked;
    }

    function getBalance() public view returns (uint256) {
        return stakingBalance[_msgSender()];
    }

    function getRewardRate() public view returns (uint256) {
        return rewardRate;
    }

    function transferToken() public {
        _BabyBlank.transfer(_msgSender(), 50 * (10**18));
    }

    function getBlankAddress() public view returns (address) {
        return address(_Blank);
    }

    function getBabyAddress() public view returns (address) {
        return address(_BabyBlank);
    }

    function depositToken(uint256 _amount) public {
        require(_amount > 0);
        _BabyBlank.transferFrom(_msgSender(), address(0), _amount);
        stakingBalance[_msgSender()] += _amount;
        totalValueLocked += _amount;
        if (!hasStaked[_msgSender()]) {
            stakers.push(_msgSender());
        }

        isStaking[_msgSender()] = true;
        hasStaked[_msgSender()] = true;

        emit StakeToken(_msgSender(), _amount);
    }

    function rewardToken() public {
        require(_msgSender() == owner);

        for (uint256 index = 0; index < stakers.length; index++) {
            address recipt = stakers[index];
            uint256 balance = (stakingBalance[recipt] * rewardRate) / 10**2;
            if (balance > 0) {
                _Blank.transfer(recipt, balance);
            }
        }
    }

    function claimReward(uint256 balance) public {
        for (uint256 index = 0; index < stakers.length; index++) {
            if (stakers[index] == _msgSender()) {
                if (balance > 0) {
                    _Blank.transfer(_msgSender(), balance);
                } else {
                    revert("wrong");
                }
                break;
            }
        }
    }

    function unstakeToken(uint256 balanceReward) public{
        uint256 balance = stakingBalance[_msgSender()];
        require(balance > 0);
        totalValueLocked -= balance;
        _BabyBlank.transfer(_msgSender(), balance);
        stakingBalance[_msgSender()] = 0;
        isStaking[_msgSender()] = false;
        claimReward(balanceReward);
    }
}
