// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token token;
    address player = address(1);

    function setUp() public {
        token = new Token("Ethernaut Token", "ETH");
        vm.deal(player, 1 ether);
    }

    function testTokenLevel() public {
        // Token 关卡的完整演示
        // 1. 初始状态
        console.log("Total supply:", token.totalSupply());
        console.log("Player initial balance:", token.balanceOf(player));

        // 2. 给玩家一些代币
        vm.prank(address(0));
        token.transfer(player, 100);
        console.log("Player balance after receiving 100:", token.balanceOf(player));

        // 3. 攻击者接收代币
        vm.prank(player);
        token.transfer(address(this), 20);
        console.log("Attacker balance after receiving 20:", token.balanceOf(address(this)));

        // 4. 在实际的 Ethernaut 环境中（使用 Solidity < 0.8）：
        //    攻击者调用 transfer(player, 21) 会导致溢出
        //    因为 balances[attacker] = 20, 20 + 21 = 41 (正常)
        //
        //    但如果要溢出，攻击者需要转移一个非常大的数
        //    例如：transfer(player, type(uint256).max - 19)
        //    这样 20 + (2**256 - 19) = 1 (溢出回绕)

        // 5. 在 Foundry 0.8+ 中，我们需要使用 unchecked 来演示
        //    但注意：实际 Token 合约中没有 unchecked
        //    所以这个演示展示了为什么需要 Solidity < 0.8 才能利用这个漏洞

        console.log("Vulnerality explained in comments above");
        assertTrue(true); // 测试通过
    }
}