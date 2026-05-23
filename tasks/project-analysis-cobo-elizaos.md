# AI × Web3 项目拆解：Cobo Agentic Wallet & ElizaOS

> 拆解时间：2026-05-23
> 任务：拆解 1–2 个 AI × Web3 项目或个人（30分）
> 关联 Hackathon 方向：Agent Payments / AI-native Wallet

---

## 项目一：Cobo Agentic Wallet

**简介：** Cobo 于 2026 年 4 月发布的面向 AI Agent 的自托管钱包产品，专为 AI 自主链上交易设计。

### 架构亮点

**1. Pact 机制（核心创新）**
- 合约级别的权限策略，定义 Agent 能做什么、不能做什么
- 不是简单的"签名/不签名"，而是细粒度约束：金额上限、白名单地址、时间窗口、合约调用限制
- 类比：类似 Linux 的 seccomp 策略，但跑在链上

**2. MPC 自托管**
- 业界首个 MPC-based 自托管 Agent 钱包
- Agent 永远看不到完整私钥 — 即使 Agent 被攻破，资金安全
- 支持多链（EVM、Solana 等）

**3. SDK + Recipe 库**
- 提供开发工具包和可复用的功能模版（swap、stake、pay 等）
- Agent 可以像调用 API 一样调用链上操作

### 与 Hackathon 的关联
- ✅ **Agent 权限模型** — Pact 机制直接回答"Agent 能拿多少钱、能花多少"
- ✅ **自托管安全** — Agent 不触碰私钥，解决信任问题
- ✅ **SDK 生态** — 可以直接拿来构建 Agent Payments 原型
- 学习重点：Pact 的权限策略设计、MPC 签名流程

---

## 项目二：ElizaOS（原 ai16z）

**简介：** GitHub 上最受欢迎的 AI Agent 开源框架（TypeScript），运行在 Solana 上。

### 架构亮点

**1. 模块化 Agent 框架**
- TypeScript 构建，支持多平台接入（Discord、Twitter、Telegram）
- 内置钱包管理、链上身份验证、资产管理
- Agent 可以自主执行交易、管理社区、分析数据

**2. 多 Agent 协作**
- 原生支持多 Agent 模拟和协作
- 不同 Agent 可以分工：投资分析 → 策略执行 → 结果报告

**3. AI16Z 治理代币**
- 代币持有者参与 DAO 治理（投资提案、回购等）
- 代币经济驱动 Agent 生态发展

### 与 Hackathon 的关联
- ✅ **开源框架** — 可以直接 fork 或参考架构做 Agent Payments
- ✅ **钱包集成** — 学习其钱包模块设计
- ✅ **Solana 生态** — 用户熟悉 Solana，技术栈匹配
- 学习重点：Agent 生命周期管理、工具调用模式、多链钱包抽象

---

## 对比与启发

| 维度 | Cobo Agentic Wallet | ElizaOS |
|:-----|:-------------------|:--------|
| 定位 | 钱包基础设施 | Agent 开发框架 |
| 权限模型 | Pact 策略合约 | 内置钱包管理 |
| 安全方案 | MPC 自托管 | 密钥管理抽象 |
| 适用场景 | Agent 支付/结算 | 全功能 Agent 开发 |
| 开源 | SDK 开放 | 完全开源 |

**对我们的 Hackathon 的启发：**
1. **权限是核心** — Pact 的白名单+限额+时间窗口模式值得参考
2. **安全第一** — MPC 让 Agent 不触碰私钥，这是落地必需的
3. **抽象钱包层** — 无论用 Cobo 还是 ElizaOS 的模式，都需要一个 Wallet Abstraction Layer
4. **先最小可行** — 参考 ElizaOS 的模块化思路，先做一个最小 Agent Payments 原型

---

## 参考链接
- Cobo Agentic Wallet: https://www.cobo.com/
- Cobo Blog: https://www.cobo.com/blog
- ElizaOS: https://elizaos.ai/
- ElizaOS GitHub: https://github.com/elizaos/eliza
