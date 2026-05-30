# Week 2｜Security / Privacy｜Agent Workflow Threat Model 与确认策略

## 背景

以 Agentic Commerce 场景为例：Agent 替用户发起商业动作（购买 API、数据、推理服务），涉及 Payment Intent、Budget Control、Proof of Task Completion、Escrow Flow 等环节。

## 资产清单

| 资产 | 说明 | 风险等级 |
|------|------|----------|
| Payment Intent | 用户授权的花钱意图结构（capability、budget cap、acceptance rules） | 🔴 高 |
| Budget Cap | 单笔/累计支出上限 | 🔴 高 |
| API Key / Session Key | Agent 调用服务和签名交易的凭证 | 🔴 高 |
| Receipt / Proof | 服务交付后的执行证据（签名日志、哈希链） | 🟡 中 |
| Escrow Fund | 锁在托管合约中的资金 | 🔴 高 |
| Service Output | API 返回的数据、推理结果 | 🟢 低 |

## Threat Model

### T1: Payment Intent Manipulation（支付意图篡改）

**攻击者：** Prompt Injection / 恶意服务方
**攻击路径：** 攻击者通过注入恶意上下文，诱导 Agent 修改已签名的 Payment Intent 中的 budget cap 或 service criteria
**影响：** 支出超出用户授权上限，买到不符合要求的服务
**防御：**
- Payment Intent 的 budget cap 和 criteria 必须在用户端签名锁定，Agent 无权修改
- Policy 层（确定性代码）与 AI 模型隔离，Policy 检查先于执行

### T2: Budget Control Bypass（预算控制绕过）

**攻击者：** 恶意 Agent / 被污染的模型输出
**攻击路径：** Agent 构造多个小额请求累积突破 total_cap，或通过不同服务分散支出绕过单点限制
**影响：** 日累计/总预算被消耗殆尽
**防御：**
- 单笔上限 + 累计上限 + 时间窗口三重约束
- Agent 每笔请求必须携带 signed intent，服务方/Payment Gateway 需验证 intent 与当前消费窗口
- 拒绝超限请求，不允许"分批绕过"

### T3: Proof of Task Completion Fraud（交付证明伪造）

**攻击者：** 恶意服务方
**攻击路径：** 服务方伪造 execution log、篡改 output hash 或重放旧 receipt
**影响：** 用户为未执行或错误执行的服务付款
**防御：**
- 服务方签名 + 链上哈希锚定：执行前约定 input hash，执行后签名 output hash + input hash + timestamp
- 链上验证合约检查签名和 hash 一致性
- 高风险任务引入 TEE attestation 或第三方 evaluator

### T4: Escrow Abuse（托管机制滥用）

**攻击者：** 服务方 / 用户
**攻击路径：**
- 服务方提交虚假完成证明触发释放
- 用户恶意拒绝验收，导致服务方资金锁死超时
**影响：** 资金错误释放或滞压
**防御：**
- 引入 evaluator 角色或 oracle 验证交付质量
- 超时自动回滚 + dispute window（争议窗口）
- 小额快速释放，高价值引入人工仲裁

### T5: Agent Authorization Boundary Breach（Agent 越权）

**攻击者：** Prompt Injection / 恶意上下文
**攻击路径：** 攻击者让 Agent 认为自己是"管理员"，绕过 constrained spender 边界发起未授权的商业动作
**影响：** Agent 在预算外发起交易、签名、授权合约等高风险操作
**防御：**
- Agent 钱包使用 Session Key + Policy（Cobo CAW Pact 模式）：任务级临时授权
- 高风险动作（签名、approve、部署、升级）必须暂停并请求人工确认
- 所有动作记录到 audit log，事后可复盘

## 确认策略（低风险自动 / 高风险人工确认）

| 动作类型 | 示例 | 执行方式 |
|----------|------|----------|
| 查询/读取 | 查价格、查余额、查 API 文档 | ✅ 自动执行 |
| 小额支付 | < $1 的单次 API 调用 | ✅ Policy 内自动 |
| 中等支付 | $1–$50 的单次服务购买 | ⚠️ 需模拟 + 日志 + 可撤销 |
| 大额支付 | > $50 或累计超限 | 🛑 人工确认 |
| 签名/授权 | approve、deploy、权限变更 | 🛑 始终人工确认 |
| 争议申报 | 发起退款、投诉 | 🛑 始终人工确认 |

## 核心原则

> 系统设计目标不是让 Agent 永不犯错，而是让 Agent 犯错时无法直接造成不可接受损失。
> -- Handbook Bridge, AI Security 章

所有防御措施围绕 bounded risk envelope 展开：每笔 Agent 商业动作的损失上限由用户在 Payment Intent 中锁定，Policy 层确保这个上限不可被 AI 模型突破。
