pragma solidity ^0.8.0;
import "forge-std/Script.sol";
interface Itoken {
   function transfer(address _to, uint256 _value) external returns (bool);
   function balanceOf(address _owner) external view returns (uint256 balance);
}

contract ToeknScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        Itoken token = Itoken(0x9012C7AB2aF865309a6DfDa9e2C2317eDD62b5D9);
        vm.startBroadcast(privateKey);
        token.transfer(address(0), 21);
        
        vm.stopBroadcast();
    }
}