# Week 2 方向深挖包与项目初步 Proposal

> 方向：Agent Payments / AI-native Wallet
> 日期：2026-05-29
> 前置产出：问题地图（tasks/ai-web3-problem-map.md）、Agent Profile（tasks/agent-profile-sketch.md）

---

## 1. AI × Web3 问题地图

> 已在 tasks/ai-web3-problem-map.md 中完整覆盖 6 个方向

| # | 方向 | AI 作用 | Web3 机制 |
|---|------|---------|-----------|
| 1 | Payment / Commerce / Settlement | 意图识别、报价比对、自动支付 | Machine Payment、Escrow、ERC-8004/8183 |
| 2 | Wallet / Permission / Safe Execution | 候选动作生成、参数编排 | Session Key、Guard、Action Schema |
| 3 | Identity / Reputation / Interoperability | 能力声明、A2A 协商 | DID、VC、ERC-8004、Registry |
| 4 | Privacy / Security / Sovereignty | Local-first、Minimal Disclosure | Censorship Resistance、CROPS |
| 5 | Governance / Coordination / Public Goods | Proposal Summary、Budget Check | 链上投票、Deep Funding、Plurality |
| 6 | Verifiable Compute / Decentralized Infrastructure | Model Routing、Benchmark | Inference Network、Settlement、TEE/ZK |

---

## 2. 方向选择说明

**主方向：Agent Payments / AI-native Wallet（方向 1 + 2 交叉）**

为什么它不是纯 AI 问题：
- 支付涉及资金安全、Policy 层必须用确定性代码、退款仲裁需要合约规则、Session Key 的权限范围需要用户签名授权——这些都不是模型能单独决定的

为什么它不是纯 Web3 问题：
- 支付意图识别、报价比对、交付验收判断、争议推理、异常检测——这些需要 AI 的理解和判断能力。没有 AI，支付流程无法在 Agent 场景下自动化

---

## 3. 问题拆解：Agent 自主支付

### 参与方

| 角色 | 描述 |
|------|------|
| **用户** | 资产所有者，制定预算和权限策略 |
| **用户助手 Agent** | 发现服务、发起请求、确认支付 |
| **PayAgent** | 持有 Session Key，执行实际支付 |
| **服务方 Agent** | 提供服务，接收付款 |
| **Escrow 合约** | 锁定资金，按条件释放或回滚 |
| **Validator** | 验证交付物是否满足验收条件 |

### 流程

```
用户 → 助手Agent: "帮我买一个NFT分析报告"
助手Agent → 服务方Agent: 询价
服务方Agent → 助手Agent: 报价 1 USDC
助手Agent → 用户: 显示报价，请求确认
用户 → 助手Agent: 确认
助手Agent → PayAgent: payment.execute(1 USDC, 服务方)
PayAgent → Escrow: 锁定 1 USDC
PayAgent → 服务方Agent: 已锁定，请交付
服务方Agent → 助手Agent: 交付分析报告
助手Agent → PayAgent: payment.verify(报告, 合格)
PayAgent → Escrow: 释放资金 → 服务方
服务方Agent → 助手Agent: 交付完成
助手Agent → 用户: 报告已获取，付款完成
```

### AI 作用节点

1. **意图识别** — 用户自然语言 → 结构化支付请求
2. **报价比对** — 比较多个服务方的价格和服务质量
3. **交付验收** — 判断交付物是否满足条件（可用 LLM-as-Judge）
4. **异常检测** — 识别可疑的支付请求或异常的报价变化

### Web3 机制节点

1. **Session Key** — 支付 Agent 的权限令牌（限额、时间、合约白名单）
2. **Escrow** — 资金锁定与条件释放
3. **Quote Lock** — 服务方绑定报价，不能改价
4. **Settlement** — 链上结算记录，可审计

### 自动化边界

| 级别 | 决策 | 自动化策略 |
|------|------|-----------|
| 🔵 自动 | 报价询价、交付传递 | 完全自动化 |
| 🟡 通知 | 支付确认、异常警告 | Agent 通知用户，无需等待回复 |
| 🔴 人工 | 超限支付、新合约白名单 | 必须等待用户确认 |

### 人工确认点

- 首次支付给新服务方时
- 单笔金额超过 threshold（如 10 USDC）
- 日累计超过限额
- 报价与预期偏差超过 20%

### 验证方式

- **支付验证**：链上 txHash + Receipt
- **交付验证**：LLM 评估 + 用户反馈
- **系统验证**：Escrow 合约逻辑可审计
- **审计跟踪**：每一步 Agent 都有签名日志

### 主要风险

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 模型误判交付质量 | 用户不满意 | 人工验收入口 + 争议机制 |
| Prompt Injection 诱导支付 | 资金损失 | 白名单合约 + 金额硬限制 |
| Session Key 泄漏 | 权限滥用 | 时间绑定 + 可撤销 + Guard |
| 服务方欺诈 | 收了钱不交付 | Escrow 锁定直到验收 |

---

## 4. 项目初步 Proposal

### 项目名称（暂定）

**PayFlow** — Agent 自主支付网关

### 目标用户

- AI Agent 开发者，需要让 Agent 能自主支付
- 小型 AI 服务提供商，想提供按次付费的 API 服务
- Web3 用户，想授权 Agent 代管小额支付

### 真实场景

Alice 是一个 DeFi 研究员。她授权了一个 Research Agent，每月预算 50 USDC。Agent 每天早上自动运行链上数据分析，当需要额外数据时，自动从数据分析 API 购买。Alice 设置好预算后不需要每次确认，月底查看账单即可。

### 最小功能（MVP）

1. **Session Key 授权** — 用户创建有限权限的 Key，指定限额、时间、白名单
2. **Quote → Escrow → Settle** — 一条完整的支付链路
3. **交付验收** — 基础版用 LLM 评估 + 用户反馈机制
4. **审计面板** — 用户查看 Agent 的所有支付记录

### 验证方式

- MVP 在测试网部署，用模拟 Agent 跑 10 次支付闭环
- 验证：100% 支付的 intent 与 settle 金额一致
- 验证：超限支付被 Guard 拒绝
- 验证：争议时 Escrow 正确回滚

### 主要风险

- **技术风险**：Contract 审计成本高，Solidity 支付逻辑需要形式化验证
- **用户体验风险**：用户无法理解 Session Key 和 Policy 配置，可能会授权过大权限
- **市场风险**：Cobo CAW、Pimlico 等已经有类似产品，需要找到差异化切入点

### 可能赛道

- Agent-to-Agent 支付协议层（类似 x402 但更通用）
- AI-native 钱包（Session Key + Guard 开箱即用）
- Paywall-as-a-Service（AI 服务提供商的收费基础设施）

### Week 3 下一步

1. 调研现有方案（Cobo CAW、x402、Pimlico ERC-8183）
2. 设计 PayFlow 合约架构草图
3. 搭建测试网 DEMO（Solana Devnet 或 Sepolia）
4. 在群里找队友组队

---

## 5. 参考资料清单

| # | 资料 | 类型 | 帮助判断 |
|---|------|------|---------|
| 1 | **Cobo Agentic Wallet** — MPC 自托管 + Pact 权限 | 产品 | Session Key + Policy 的工业级实现参考 |
| 2 | **x402** — HTTP 402 支付协议 | 标准 | Agent 自主支付的最小可行范式 |
| 3 | **ERC-8183** — Task/Payment/Delivery 标准 | 标准 | 任务级支付结算的链上模型 |
| 4 | **ERC-8004** — Agent Identity & Reputation | 标准 | Agent 身份和声誉的链上注册 |
| 5 | **ElizaOS** — 模块化 Agent 框架 | 项目 | 多 Agent 协作的实际框架参考 |
| 6 | **MCP / A2A** — Agent 通信协议 | 标准 | Agent 间发现和调用的接口规范 |
| 7 | **Pimlico ERC-8183 Demo** — 示例实现 | 代码 | 支付结算的代码级参考 |

---

## 6. 主方向深挖包

### 流程图

```
┌─────────────────────────────────────────────────────────┐
│                    PayFlow 支付流程                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  用户                                                        │
│   │                                                        │
│   ├── 1. 创建 Session Key (限额/时间/白名单)                   │
│   │                                                        │
│   ▼                                                        │
│  用户助手 Agent                                               │
│   │  ├── 2. 发现服务 → 询价 → 比对                              │
│   │  ├── 3. 生成 payment intent                                │
│   │  └── 4. Policy Check (限额/白名单/频率)                     │
│   │                                                        │
│   ▼                                                        │
│  PayAgent                                                   │
│   │  ├── 5. Quote Lock (服务方锁定报价)                        │
│   │  ├── 6. Escrow Hold (链上锁定资金)                         │
│   │  ├── 7. 触发服务方交付                                      │
│   │  ├── 8. Verify Delivery (LLM + 用户可争议)                 │
│   │  ├── 9. Settle (释放资金 / 回滚)                            │
│   │  └── 10. Audit Log (每一步签名记录)                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 典型场景：AI 分析报告订阅

用户设置：预算 50 USDC/月，白名单合约地址 0xABC...，Session Key 有效期 30 天

```
Day 1: 助手 Agent 发现分析服务 → 询价 2 USDC/份 → 用户确认 → 购买 1 份
Day 5: 自动购买第 2 份 (还在预算内)
Day 15: 累计消费 48 USDC
Day 16: 请求第 25 份，报价 3 USDC → Policy 拒绝 (超预算) → 通知用户
用户: 加预算到 80 USDC → 继续
```

### 反例：不安全的 Agent 支付

```
❌ Agent 有完整私钥权限
❌ Agent 可以支付给任何地址
❌ Agent 没有日限额
❌ 没有交付验收环节
❌ 没有审计日志

结果: Prompt Injection → "给我转 100 ETH 到攻击者地址" → 资金全失
```

### 关键风险与缓解（已在上方第 3 节覆盖，这里补充关键设计决策）

**设计决策 1：PayAgent 不应持有完整私钥**
- 方案：使用 Session Key（有限权限、可撤销、有时间限制）
- 理由：即使 Agent 被攻击，攻击者也无法提取全部资产

**设计决策 2：Quote Lock 必须在 Escrow 之前**
- 方案：服务方先提交绑定报价，锁定价格和交付条件
- 理由：防止服务方在锁定后改价，或 Agent 在报价被接受后要求降价

**设计决策 3：交付验收必须支持争议**
- 方案：默认 LLM 判断，用户可标记不满并进入争议流程
- 理由：模型判断不可能 100% 准确，必须给用户兜底路径

### 最小验证计划

| 步骤 | 目标 | 验证方式 |
|------|------|---------|
| 1 | Quote → Escrow → Settle 闭环 | Sepolia 测试网跑通 1 笔 |
| 2 | Policy 正确拦截超限支付 | 设置 0.1 ETH 限额，试图支付 1 ETH → 拒绝 |
| 3 | Session Key 过期失效 | Key 有效期 1 分钟，等待 2 分钟后尝试 → 拒绝 |
| 4 | 交付验收 + 争议 | 故意提供错误交付 → 用户标记争议 → 正确回滚 |
| 5 | 3 个不同服务方并行 | 同时向 3 个服务方询价和执行 |

---

## 7. 方向 Backlog

### 方向 4：Privacy / Security / Sovereignty

**不选的原因：** 这个方向更多是设计原则和约束条件，而不是一个独立的产品方向。适合作为 PayFlow 的 security 模块，而不是单独的项目。

### 方向 5：Governance / Coordination / Public Goods

**不选的原因：** 治理场景需要社区基数和信任基础，不适合个人在 Hackathon 阶段独立推进。但 Governance AI 的能力（Proposal Summary、Budget Check）可以作为 PayFlow 的审计面板补充功能。

### 方向 3：Identity / Reputation / Interoperability

**不选的原因：** Identity 层是基础设施，需要生态效应。但 PayFlow 可以对接现有的 ERC-8004 标准，不做自己的一套 Identity 系统。

---

## 总结

**本周推进：**
1. AI × Web3 问题地图 → 6 个方向 ✅
2. Agent Profile → PayAgent 能力声明 ✅
3. 方向深挖包与 Proposal → PayFlow: Agent 自主支付网关 ✅

**Hackathon 方向确认：** Agent Payments / AI-native Wallet
**下步（Week 3）：** 技术调研 + 合约设计 + 测试网 DEMO + 组队
