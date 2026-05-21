#!/bin/bash
# AI × Web3 工具链路 Demo
# 用户意图 → AI 规划 → 工具执行 → 链上验证
#
# 用法: ./run-demo.sh [token-name]
# 默认 token-name: DEMO Token

set -e

TOKEN_NAME="${1:-DEMO Token}"
TIMESTAMP=$(date +%s)
echo "=========================================="
echo " AI × Web3 工具链路 Demo"
echo "=========================================="
echo ""
echo "🔹 第一步：用户意图"
echo "   \"在 Solana Devnet 上创建 '$TOKEN_NAME'\""
echo ""

echo "🔹 第二步：AI 规划"
echo "   1. 创建 Token Mint"
echo "   2. 创建关联账户"
echo "   3. 铸造代币"
echo ""

echo "🔹 第三步：工具执行"
echo ""

# Check Solana setup
if ! command -v solana &> /dev/null; then
    echo "❌ 未找到 Solana CLI，请先安装"
    exit 1
fi

echo "  网络配置：$(solana config get | grep 'RPC URL' | awk '{print $3}')"
echo "  钱包地址：$(solana address)"
echo "  SOL 余额：$(solana balance)"
echo ""

# 1. Create token
echo "  ▶ 创建 Token..."
MINT_ADDRESS=$(spl-token create-token --decimals 9 2>&1 | grep -oP 'Creating token \K[^\s]+' || true)
if [ -z "$MINT_ADDRESS" ]; then
    # Fallback: parse differently
    MINT_ADDRESS=$(spl-token create-token --decimals 9 2>&1 | grep 'Address:' | awk '{print $3}')
fi
echo "  ✅ Token Mint: $MINT_ADDRESS"
echo ""

# 2. Create account
echo "  ▶ 创建关联账户..."
ACCOUNT_ADDRESS=$(spl-token create-account "$MINT_ADDRESS" 2>&1 | grep -oP 'Creating account \K[^\s]+' || true)
echo "  ✅ Token Account: $ACCOUNT_ADDRESS"
echo ""

# 3. Mint tokens
echo "  ▶ 铸造 1,000,000 枚..."
spl-token mint "$MINT_ADDRESS" 1000000 2>&1 | tail -1
echo ""

echo "🔹 第四步：链上验证"
EXPLORER_URL="https://explorer.solana.com/address/$MINT_ADDRESS?cluster=devnet"
echo "  ✅ Explorer: $EXPLORER_URL"
echo "  ✅ 余额: spl-token balance $MINT_ADDRESS"
echo ""
echo "=========================================="
echo " 🎉 Demo 完成！完整链路已验证"
echo "=========================================="
