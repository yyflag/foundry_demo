// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract KingTest is Test {
    address kingLevel = 0xdaEa6E829a45F3bF1C0C455aa387D7dBD57F1aAF;

    function testKingLevel() public {
        // 检查当前 king
        console.log("Current king:", IKing(kingLevel).king());

        // 部署攻击合约
        KingExploit exploit = new KingExploit{value: 1 ether}(payable(kingLevel));

        // 再次检查 king
        address newKing = IKing(kingLevel).king();
        console.log("New king:", newKing);

        // 验证攻击成功
        assertEq(newKing, address(exploit));

        console.log("King level completed successfully!");
    }
}

interface IKing {
    function king() external view returns (address);
    function claimThrone() external payable;
}