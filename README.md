# Foundry Ethernaut 通关学习仓库

> 使用 Foundry 框架解 OpenZeppelin Ethernaut 安全挑战，包含完整测试用例、exploit 脚本和解题笔记。

---

## 🎯 项目概况

- **目标**：通过 Foundry 本地复现并解决 Ethernaut 所有关卡
- **技术栈**：Foundry + Solidity + GitHub Actions
- **适用对象**：智能合约安全初学者 → 进阶学习者
- **关卡进度**：✅ Level 01-05 | 🔄 Level 06-10 | ⏳ Level 11-20

---

## 📂 仓库结构

foundry_demo/
├── src/                    # Ethernaut 关卡合约（已部署到本地 Foundry 测试网）
├── test/                   # 关卡测试文件（每个关卡独立）
│   ├── level-01-HelloWeb3.sol
│   ├── level-02-Fallback.sol
│   └── ...
├── script/                 # 攻击脚本（exploit 实现）
│   ├── level-01-HelloWeb3.s.sol
│   └── ...
├── lib/                    # 第三方依赖（OpenZeppelin、foundry-utils 等）
├── .github/workflows/      # CI（自动化测试）
├── foundry.toml           # Foundry 配置
└── NOTES.md               # 个人解题笔记（可选）
---
## 🚀 快速开始
### 1. 环境准备
```bash
# 安装 Foundry（如未安装）
curl -L https://foundry.paradigm.xyz | bash
foundryup
# 验证安装
forge --version
2. 克隆并安装依赖
git clone https://github.com/yyflag/foundry_demo.git
cd foundry_demo

# 安装 OpenZeppelin 等依赖
forge install
3. 运行测试
# 运行所有关卡
forge test

# 运行单个关卡（示例：Level 01）
forge test --match-test testLevel01HelloWeb3

# 显示详细输出
forge test -vvv

# 运行攻击脚本
forge script script/level-01-HelloWeb3.s.sol
🎮 关卡攻略索引
关卡
名称
难度
核心漏洞
状态
01
HelloWeb3
⭐☆☆
call 调用、权限绕过
✅ 完成
02
Fallback
⭐⭐☆
Fallback 函数、ETH 转账
✅ 完成
03
Coin Flip
⭐⭐☆
伪随机数预测
✅ 完成
04
Telephone
⭐⭐⭐
tx.origin vs msg.sender
🔄 进行中
05
Token
⭐⭐⭐
整数溢出
⏳ 待开始
...
...
...
...
...
详细解题思路见 NOTES.md。
💡 核心学习点
Level 01 - HelloWeb3
漏洞类型：权限控制不当
攻击手法：使用 call 直接调用函数绕过 onlyPlayer 修饰符
关键代码：
Level 02 - Fallback
漏洞类型：Fallback 函数逻辑错误
攻击手法：向合约发送 ETH（value > 0）且不带 calldata，触发 fallback
关键代码：
🛠️ Foundry 配置说明
foundry.toml 关键配置
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
ffi = true            # 允许调用外部命令
ast = true            # 生成 AST 用于分析
optimizer = true
optimizer_runs = 200
solc = "0.8.20"       # 与 Ethernaut 一致的版本

[profile.local]
rpc_url = "http://127.0.0.1:8545"  # 本地 Anvil 节点
本地测试网（Anvil）
# 启动本地节点（可选，Foundry 默认使用内置测试链）
anvil --port 8545 --accounts 10 --balance 1000000000000000000000

# 查看账户和私钥
anvil --list
📊 测试覆盖率
# 生成覆盖率报告
forge coverage --report debug

# 输出到文件
forge coverage --output-file coverage.json

当前覆盖率：~85%（目标：100%）
🔍 常见问题
Q1: 测试失败，提示 "revert"
A: 确保攻击顺序正确，某些关卡需要先完成前置条件。
Q2: 如何调试？
A: 使用 console.log 或 --debug 模式：
forge test --debug
Q3: 为什么不用 Hardhat？
A: Foundry 本地执行速度快，且测试用 Solidity 编写，更贴近合约逻辑。
📚 参考资料
Ethernaut 官网
Foundry Book
OpenZeppelin Contracts
Smart Contract Security Best Practices
🤝 贡献
欢迎提交 PR！如果你有更优雅的攻击方案或发现了新的漏洞变体，请务必分享。
⚠️ 免责声明
本项目仅用于学习研究！所有攻击代码请在本地 Foundry 环境运行，禁止用于真实网络攻击。
Happy Hacking! 🎯

最后更新：2026-04-09
