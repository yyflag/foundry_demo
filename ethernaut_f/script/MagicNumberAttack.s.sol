// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IMagicNumber {
    function setSolver(address _solver) external;
    function solver() external view returns (address);
}

contract MagicNumberAttackScript is Script {
    function run() external {
        address magicNumberLevel = 0x9bbDfd4E0A1a894D642FEC20f2678eFA1dEb9784;

        // creation code (12 字节) + runtime code (10 字节)
        // creation: 把 runtime 复制到内存并 RETURN，让 EVM 写入链上
        // runtime : 任何调用返回 42 (bytes32)
        bytes memory bytecode = hex"600a600c600039600a6000f3602a60805260206080f3";

        vm.startBroadcast();

        // 用 inline assembly 部署原始字节码
        address solver;
        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        require(solver != address(0), "deploy failed");
        require(solver.code.length == 10, "runtime size must be 10 bytes");

        console.log("Solver deployed at:", solver);
        console.log("Runtime code size:", solver.code.length);

        // 把 solver 注册到 MagicNumber
        IMagicNumber(magicNumberLevel).setSolver(solver);

        vm.stopBroadcast();
    }
}
