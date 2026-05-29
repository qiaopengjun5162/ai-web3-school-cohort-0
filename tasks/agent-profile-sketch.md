# Agent Profile 与能力声明草图

> Week 2 Module C — Agent Identity
> 日期：2026-05-29
> 设计场景：Agent Payments / AI-native Wallet 方向的支付 Agent

---

## 1. Agent 概要

| 字段 | 内容 |
|------|------|
| **名称** | PayAgent |
| **类型** | 支付执行 Agent |
| **维护者** | qiaopengjun5162 |
| **版本** | 0.1 (草图) |
| **身份 DID** | `did:key:z6Mk...`（待生成） |
| **Registry** | 待注册（参考 ERC-8004） |

---

## 2. Capability（能力声明）

### 核心能力

| 能力 | 描述 | 输入 | 输出 |
|------|------|------|------|
| `payment.execute` | 执行预授权的链上支付 | `{to, amount, chainId, token}` | `{txHash, status}` |
| `payment.quote` | 获取并锁定报价 | `{serviceId, params}` | `{price, expiry, lockId}` |
| `payment.verify` | 验证交付并释放资金 | `{deliveryProof, escrowId}` | `{verified, reason}` |
| `budget.check` | 检查预算和 Policy 约束 | `{action, amount, sessionKey}` | `{allowed, limit, reason}` |

### 限制声明

- 单笔最大支付：受 Session Key 限制
- 日累计限额：受 Policy 限制
- 仅限白名单合约地址
- 高风险操作必须 Human-in-the-loop

---

## 3. 调用方式（Service Endpoint）

### A2A 通信

```
Agent A (用户助手) → Agent B (PayAgent)
1. A 发送 payment.quote 请求
2. B 返回报价 + lockId
3. A 发送 user 确认签名
4. B 执行 payment.execute
5. B 返回 txHash
```

### 接口规范

```json
{
  "agent": "did:key:payagent",
  "protocol": "a2a-v1",
  "endpoints": [
    {
      "type": "grpc",
      "url": "grpc://payagent.local:8443",
      "auth": "session-key"
    },
    {
      "type": "https",
      "url": "https://api.payagent.dev/v1",
      "auth": "bearer-token"
    }
  ]
}
```

---

## 4. 收费模型

| 服务 | 费用 | 方式 |
|------|------|------|
| 报价查询 (quote) | 免费 | — |
| 支付执行 (execute) | Gas + 0.1% 手续费 | 自动扣除 |
| 争议仲裁 (dispute) | 固定 5 USDC | 失败方承担 |
| 紧急撤销 (revoke) | 免费 | 用户发起 |

---

## 5. 验证方式

| 验证维度 | 方法 |
|----------|------|
| **身份验证** | DID + Verifiable Credential |
| **执行证明** | txHash + 链上收据 |
| **代码可验证** | 开源合约 + 形式化验证 |
| **审计跟踪** | 每一步都有签名日志，敏感信息加密存储 |

---

## 6. 失败处理

| 场景 | 处理方式 |
|------|----------|
| 报价过期 | 返回错误，用户重新询价 |
| 支付失败 | 自动退款至 Escrow，返回错误码 |
| 争议 | 提交至链上仲裁合约，锁定资金直到裁决 |
| Policy 拒绝 | 返回拒绝原因 + 当前限额状态 |
| Agent 故障 | 超时自动回滚 Escrow，用户可手动撤销 |

---

## 7. 协议对比（加分项：MCP vs A2A vs ERC-8004 vs MPP）

| 协议 | 解决的问题 | 适合场景 | 与 PayAgent 的关系 |
|------|-----------|---------|-------------------|
| **MCP** | Agent ↔ 工具的标准协议 | 本地/远程工具调用 | PayAgent 开放 MCP server，供其他 Agent 发现和调用支付能力 |
| **A2A** | Agent ↔ Agent 发现/通信/协商 | 跨 Agent 协作 | PayAgent 通过 A2A 与用户助手 Agent 协商报价和执行 |
| **ERC-8004** | Agent 身份与声誉上链 | 链上 Agent Registry | PayAgent 在链上注册身份，声誉随交易记录累积 |
| **MPP** | Machine Payment 的意图→结算流程 | 自主支付闭环 | PayAgent 直接实现 MPP 的 Quote→Escrow→Settle 流程 |

**一句话总结：** MCP 让 PayAgent 被调用，A2A 让 PayAgent 被协商，ERC-8004 让 PayAgent 可验证，MPP 让 PayAgent 能收钱。
