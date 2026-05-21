# 受限 Web3 助手 Workflow

## 概述

一个基于 Hermes Agent 的受限 Web3 助手，专注完成「Solana Devnet SPL Token 创建」这一特定任务。助手有明确的能力边界，不做超出范围的操作。

## 设计原则

1. **能力受限** — 只操作 Solana Devnet，不会触及 Mainnet
2. **任务拆解** — 用户意图 → AI 拆解为原子步骤
3. **工具绑定** — 只使用预定义的 CLI 工具集（solana, spl-token）
4. **验证闭环** — 每一步执行结果都通过链上检查验证
5. **人机协作** — 用户提供意图和验收，Agent 负责执行

## 架构图

```
┌─────────────────────────────────────────────────────┐
│                  用户 (Human)                        │
│             提供意图 / 验收结果                        │
└──────────┬──────────────────────────────────────────┘
           │ "帮我创建一个 SPL Token"
           ▼
┌─────────────────────────────────────────────────────┐
│              Hermes Agent (AI)                       │
│                                                      │
│  1. 意图理解 → 2. 任务拆解 → 3. 工具编排 → 4. 验证   │
└──────────┬──────────────────────────────────────────┘
           │ spl-token create-token
           │ spl-token create-account
           │ spl-token mint
           ▼
┌─────────────────────────────────────────────────────┐
│            Solana Devnet (Web3)                      │
│                                                      │
│  Token Mint → ATA → Mint Tx → Explorer 验证          │
└─────────────────────────────────────────────────────┘
```

## Workflow 步骤

### 第1步：意图理解

**输入：** 用户自然语言指令
```
"在 Solana Devnet 上创建一个 SPL Token，精度9位，铸造100万个"
```

**规则：**
- 只接受 Solana Devnet 相关指令
- Mainnet / 其他链请求 → 拒绝并提示能力范围
- 参数缺失 → 使用合理默认值（Token名: "Learning Token"，精度: 9，数量: 1,000,000）

### 第2步：任务拆解

AI 自动拆解为 3 个原子步骤，按依赖顺序排列：

| 步骤 | 操作 | 依赖 | CLI 命令 |
|:----:|------|:----:|----------|
| 1 | 创建 Token Mint | 无 | `spl-token create-token --decimals 9` |
| 2 | 创建 Associated Token Account | 需要 Mint Address | `spl-token create-account <MINT>` |
| 3 | 铸造代币 | 需要 Token Account | `spl-token mint <MINT> <AMOUNT>` |

**约束：** 每一步失败则停止，返回错误信息，不跳过。

### 第3步：工具执行

使用受限的 CLI 工具集：

```bash
# 允许的工具
solana config get        # 检查网络配置
solana address           # 获取钱包地址
solana balance           # 检查余额
spl-token create-token   # 创建 Token
spl-token create-account # 创建账户
spl-token mint           # 铸造代币
spl-token balance        # 查询余额

# 禁止的工具/操作
solana transfer          # ❌ 转账（超出范围）
solana deploy            # ❌ 部署程序（超出范围）
spl-token burn           # ❌ 销毁（超出范围）
spl-token close          # ❌ 关闭账户（超出范围）
```

### 第4步：链上验证

每个步骤执行后自动验证：

1. **创建 Token → 验证**
   - 检查返回的 Mint Address 格式（base58, 32-44字符）
   - 通过 Explorer URL 确认链上存在

2. **创建账户 → 验证**
   - 确认返回的 Account Address 格式正确
   - 检查该账户关联到正确的 Mint

3. **铸造 → 验证**
   - `spl-token balance <MINT>` 确认余额 = 铸造数量
   - Explorer 检查最新交易记录

### 第5步：结果输出

以结构化格式呈现最终结果：

```
✅ 完成
├── Mint: CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3
├── 余额: 1,000,000 QINTUOBANG
└── Explorer: https://explorer.solana.com/address/...?cluster=devnet
```

## 安全约束

| 约束 | 规则 |
|------|------|
| 网络限制 | 仅限 Devnet，拒绝 Mainnet 操作 |
| 工具白名单 | 只允许 solana + spl-token 的子命令子集 |
| 金额上限 | 单次铸造不超过 10,000,000 |
| 操作确认 | 执行前向用户展示完整命令计划 |
| 错误处理 | 任何步骤失败 → 停止并报告，不自动重试 |
| 数据保护 | 不记录/上传私钥、助记词、API Key |

## 实际运行记录

- **日期:** 2026-05-20
- **Token名:** QINTUOBANG
- **Mint地址:** CU1LRRpuWkhXpNP5dbBJHVpbVSpvnEJNsom2sZGWcPq3
- **铸造数量:** 1,000,000
- **完整耗时:** ~30秒（从用户发消息到链上确认）
- **工具调用:** 4次终端命令（含一次 solana airdrop）
- **验证方式:** Solana Explorer + spl-token balance

## 局限性

1. 只能创建 SPL Token，不支持其他 Token 标准（ERC-20 等）
2. 没有图形界面，仅 CLI
3. 铸造后不支持修改（Mint Authority 已关闭的场景需额外处理）
4. 不支持批量操作（一次只能创建一个 Token）
5. 依赖 Devnet 水龙头可用性
