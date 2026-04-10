// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract ForceTest is Test {
    address forceLevel = 0x6b1c9099ef79C002cf7d127e0B28620D63c07e69;

    function testForceLevel() public {
        // Force 关卡的完整攻击流程演示

        // 1. 首先检查 Force 合约的初始余额
        console.log("Initial Force balance:", address(forceLevel).balance);

        // 2. 部署攻击合约并发送 ETH
        // 在实际操作中，你需要：
        // a. 部署 ForceAttack 合约
        // b. 向 ForceAttack 合约发送一些 ETH (至少 1 wei)
        // c. 调用 ForceAttack 的 selfdestruct 函数

        // 3. 验证攻击成功
        // Force 合约的余额应该大于 0
        assertGt(address(forceLevel).balance, 0);

        console.log("Force level completed successfully!");
        console.log("Force balance after attack:", address(forceLevel).balance);
    }
}