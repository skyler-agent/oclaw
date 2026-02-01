#!/bin/bash
# OpenClaw + MiniMax Portal OAuth Quick Setup Script
# Usage: curl -fsSL https://skyler-agent.github.io/oclaw/i.sh | bash

set -e

# Check if OpenClaw is already installed
if command -v openclaw &> /dev/null; then
  CURRENT_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
  echo "🦞 OpenClaw already installed (version: $CURRENT_VERSION)"
  echo "📦 Upgrading to latest version..."
  npm update -g openclaw
else
  echo "🦞 Installing OpenClaw..."
  npm install -g openclaw@latest
fi

echo "🔧 Fixing minimax-portal-auth plugin import path..."
PLUGIN_FILE="$(npm root -g)/openclaw/extensions/minimax-portal-auth/index.ts"
if [ -f "$PLUGIN_FILE" ]; then
  sed -i.bak 's/clawdbot\/plugin-sdk/openclaw\/plugin-sdk/g' "$PLUGIN_FILE"
  echo "   Fixed: $PLUGIN_FILE"
fi

echo "🔌 Enabling minimax-portal-auth plugin..."
openclaw plugins enable minimax-portal-auth

echo "🔄 Restarting gateway..."
openclaw gateway restart 2>/dev/null || true

echo ""
echo "✅ Setup complete! Starting OAuth configuration..."
echo ""

# Start interactive onboard process (use /dev/tty to enable interaction when run via pipe)
exec openclaw onboard --auth-choice minimax-portal < /dev/tty
