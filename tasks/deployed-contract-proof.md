# 最小智能合约部署与调用

> 项目: FHE Private Voting dApp — 基于 Zama fhEVM 的全同态加密链上投票

---

## 部署测试网合约

### Sepolia 测试网

| 合约 | 地址 | Etherscan |
|------|------|-----------|
| PrivateVoting | `0x3Ff7DA4937219FC41Ce653A0efa30C2Eb0B5AA6b` | [查看](https://sepolia.etherscan.io/address/0x3Ff7DA4937219FC41Ce653A0efa30C2Eb0B5AA6b) |
| PrivateVotingV2 | `0xdbaBBc0a2E4DFCEeE6Da20Dd00397F6f4e517AF8` | [查看](https://sepolia.etherscan.io/address/0xdbaBBc0a2E4DFCEeE6Da20Dd00397F6f4e517AF8) |

部署交易哈希（PrivateVoting）：`0x50718c4756498304a35fc8f3b55dfd75b18a662c67dfc399a6c7297137ef9273`
部署区块：10814149

### 合约功能

- `vote(bytes calldata voteHandles, bytes calldata voteProof)` — 提交加密选票
- `publishResults()` — 投票结束后公开结果
- `grantResultAccess(address viewer)` — 授权查看结果
- `getVotingMetadata()` — 读取投票元数据（标题、选项、时间窗口、阶段）

### 读取操作

- `getVotingMetadata()` — 直接读取，无需交易，无需 gas
- Etherscan 可直接调用读取函数验证

### 写入操作

- `vote()` — 需要 MetaMask 确认签名 + 支付 gas。FHE 加密选票在链下生成，链上只提交密文
- `publishResults()` — 仅 Owner 可调用，需要人工确认

### 哪些步骤必须人工确认

1. **合约部署** — 需要钱包签名 + gas 支付，确认部署参数
2. **投票** — 创建加密输入 → MetaMask 确认交易 → 链上确认
3. **公布结果** — 仅合约 Owner 可执行，调用前确认投票窗口已结束
4. **授权查看** — 确认授权地址正确，防止泄露给错误的人

### 完整流程

1. 使用 Foundry/hardhat-deploy 部署合约到 Sepolia 测试网
2. 分离线加密选票（FHE），链上只传密文
3. 投票窗口结束后，Owner 手动调用 `publishResults()`
4. 授权查看者解密并查看最终计票结果

前端已部署：https://fhevm-private-voting-nine.vercel.app/

GitHub: https://github.com/qiaopengjun5162/fhevm-private-voting
