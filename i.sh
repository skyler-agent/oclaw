#!/bin/bash
# OpenClaw + MiniMax Portal OAuth Quick Setup Script
# Usage: curl -fsSL https://raw.githubusercontent.com/skyler-agent/openclaw-minimax-setup/main/install.sh | bash

set -e

echo "🦞 Installing OpenClaw..."
npm install -g openclaw@latest

echo "🔧 Fixing minimax-portal-auth plugin import path..."
PLUGIN_FILE="$(npm root -g)/openclaw/extensions/minimax-portal-auth/index.ts"
if [ -f "$PLUGIN_FILE" ]; then
  sed -i.bak 's/clawdbot\/plugin-sdk/openclaw\/plugin-sdk/g' "$PLUGIN_FILE"
  echo "   Fixed: $PLUGIN_FILE"
fi

echo "🔌 Enabling minimax-portal-auth plugin..."
openclaw plugins enable minimax-portal-auth

echo ""
echo "✅ Installation complete! Starting OAuth setup..."
echo ""

# Start interactive onboard process
exec openclaw onboard --auth-choice minimax-portal
