# AI × Web3 问题地图与主方向选择

> Week 2 Module A — 方向研究
> 日期：2026-05-29
> 依据：Handbook Bridge 15 章全覆盖（已读完）

---

## 问题地图：6 个方向

### 1. Payment / Commerce / Settlement（支付与结算）

**AI 作用：** Agent 识别支付意图、报价比对、自动执行预算内支付、交付验收、争议仲裁推理
**Web3 机制：** Machine Payment（意图→Quote→Escrow→结算）、Session Key 权限管控、ERC-8004（身份）、ERC-8183（任务/支付/交付）

**关键问题：** Agent 如何在不暴露私钥的前提下完成自主支付？Policy 层如何平衡灵活与安全？

**对应章节：** Agent Wallet, Machine Payment, Settlement & Escrow

---

### 2. Wallet / Permission / Safe Execution（钱包与权限管控）

**AI 作用：** Agent 生成候选动作，描述意图和参数
**Web3 机制：** Smart Account + Session Key（时间/金额/合约白名单）、Guard 双层拦截（链上 Policy + 链下限流）、Action Schema 结构化接口

**关键问题：** 如何让 AI 处理不确定性但钱包执行确定性？人工确认时用户能否看懂风险？

**对应章节：** Web3 Tool Use, Agent Wallet, Chain-aware Context

---

### 3. Identity / Reputation / Interoperability（身份与互操作）

**AI 作用：** Agent 自我声明能力、跨平台身份映射、A2A 通信协商
**Web3 机制：** DID + Verifiable Credential、Agent Registry、ERC-8004、声誉/Stake/Slash 机制

**关键问题：** 身份不等于可信——信任需要可验证行为记录。A2A 通信协议（MCP vs A2A）如何选择？

**对应章节：** Agent Identity, Trust & Reputation, AI Oracle

---

### 4. Privacy / Security / Sovereignty（隐私与主权）

**AI 作用：** Local-first AI 处理敏感数据、Minimal Disclosure 只暴露最少信息
**Web3 机制：** Censorship Resistance、CROPS（去中心化基础属性）、Data Portability、User Control

**关键问题：** 没有主权设计，AI×Web3 容易变成用链上资产喂给更中心化的 AI 平台。如何保证用户能退出、迁移、选择和验证？

**对应章节：** AI Security, AI Privacy, AI Sovereignty

---

### 5. Governance / Coordination / Public Goods（治理与协调）

**AI 作用：** Proposal Summary、Meeting Action、Budget Check、Contribution Graph
**Web3 机制：** 链上投票、论坛讨论、资金流向追踪、Deep Funding、Plurality

**关键问题：** AI 辅助工具必须透明、可质疑、可复核，不能悄悄替用户投票。Source Traceability 是底线。

**对应章节：** Governance AI, Decentralized AI

---

### 6. Verifiable Compute / Decentralized Infrastructure（可验证计算与去中心化基础设施）

**AI 作用：** Model Market / Model Routing（按任务选模型）、Quality Benchmark
**Web3 机制：** Inference Network、Settlement（谁提供/谁使用/谁付款/争议处理）、TEE/ZK/zkML 验证

**关键问题：** 去中心化的是关键资源和关键决策的控制权，不一定是模型本身。开放网络带来的质量波动是否值得？

**对应章节：** Verifiable AI, Decentralized AI

---

## 两个"不是纯AI也不是纯Web3"的方向

### 方向 1：Payment / Commerce / Settlement

**不是纯 AI 问题：** 支付涉及资金安全、法律合规、汇率波动、退款仲裁——这些不是模型能单独决定的。Policy 层的权限规则必须用确定性代码写，不能交给概率模型。

**不是纯 Web3 问题：** 支付意图识别、报价比对、交付验收的判断、争议仲裁的推理——这些都需要 AI 的理解和判断能力。没有 AI，支付流程无法在 Agent 场景下自动化。

### 方向 4：Privacy / Security / Sovereignty

**不是纯 AI 问题：** 数据主权涉及法律管辖权、平台依赖、用户资产控制权——这些是 Web3 的去中心化价值观和链上治理才能解决的。

**不是纯 Web3 问题：** Prompt Injection 检测、Malicious Context 识别、Least Privilege 的最小数据原则——这些是 AI 系统特有的攻击面和设计约束。

---

## 主方向选择：Payment / Commerce / Settlement

**选择理由：**
1. 与 Handbook Bridge 最强重叠——Agent Wallet、Machine Payment、Settlement & Escrow 三章构成完整知识链
2. 与 Hackathon 方向（Agent Payments / AI-native Wallet）直接对齐
3. 可以自然扩展到 Identity 和 Security 方向的辅助问题
4. 有可实操的锚点：x402 Paywall、Cobo Agentic Wallet、CAW 等

**Week 2 后续推进：**
- 完成 Payment / Commerce 流程拆解 ✅（已提交）
- 尝试 x402 Paywall + CAW Agent 自主支付闭环（进阶 40pt）
- 整合方向深挖包与项目初步 Proposal（Week 2 总交付 40pt）
