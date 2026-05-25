// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GatekeeperTwoExploit} from "../src/GatekeeperTwoExploit.sol";

contract GatekeeperTwoAttackScript is Script {
    function run() external {
        address gatekeeperLevel = 0x0C791D1923c738AC8c4ACFD0A60382eE5FF08a23;

        vm.startBroadcast();
        new GatekeeperTwoExploit(gatekeeperLevel);
        vm.stopBroadcast();
    }
}
