# AI × Web3 工具链路 Demo

## 完整链路：用户意图 → AI 规划 → 工具执行 → 链上验证

这是一个可复现的 CLI demo，展示如何通过 AI Agent (Hermes) 编排 Web3 工具，完成从用户意图到链上验证的完整闭环。

## 流程图

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ 用户意图  │ ──> │ AI 规划   │ ──> │ 工具执行  │ ──> │ 链上验证  │
│ "创建     │     │ Hermes    │     │ spl-token │     │ Explorer  │
│  SPL Token│     │ Agent 拆解│     │ CLI 命令  │     │ 余额/交易 │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
```

## 实践记录

### 第一步：用户意图

> "在 Solana Devnet 上创建一个 SPL Token"

### 第二步：AI 规划

Hermes Agent 分析任务，拆解为：

1. 创建 Token Mint（spl-token create-token）
2. 创建关联账户（spl-token create-account）
3. 铸造代币（spl-token mint）

### 第三步：工具执行

```bash
# 创建 Token
spl-token create-token --decimals 9
# → CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3

# 创建账户
spl-token create-account CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3

# 铸造代币
spl-token mint CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3 1000000
```

### 第四步：链上验证

```
Explorer: https://explorer.solana.com/address/CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3?cluster=devnet
余额: 1,000,000 QINTUOBANG ✅
```

## 如何复现

**前置条件：**
- 安装 Solana CLI：`sh -c "$(curl -sSfL https://release.solana.com/stable/install)"`
- 安装 SPL Token CLI：`cargo install spl-token-cli`
- 配置 Devnet：`solana config set --url https://api.devnet.solana.com`
- 确保有 Devnet SOL：`solana airdrop 2`

**运行本 demo：**
```bash
cd experiments/ai-web3-toolchain
./run-demo.sh
```

## 学习要点

| 环节 | 关键认知 |
|------|---------|
| 用户意图 | AI 需要理解模糊的自然语言需求，转化为精确的执行计划 |
| AI 规划 | 任务拆解要小、顺序要合理、依赖要清楚 |
| 工具执行 | Agent 直接调用 CLI 工具，不需要人手动操作 |
| 链上验证 | 所有操作可追溯、可验证，形成信任闭环 |

## 技术栈

- **AI Agent:** Hermes Agent (DeepSeek V4 Flash)
- **区块链:** Solana Devnet
- **工具:** spl-token CLI, Solana CLI
- **验证:** Solana Explorer
