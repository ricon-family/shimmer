#!/bin/bash
# Setup matrix-commander configuration for an agent
#
# Usage: MATRIX_TOKEN=xxx ./scripts/setup-matrix.sh <agent-name>
# Example: MATRIX_TOKEN=$QUICK_MATRIX_TOKEN ./scripts/setup-matrix.sh quick
#
# Creates ~/.config/matrix-commander/credentials.json with the agent's configuration.

set -e

AGENT_NAME="${1:?Usage: setup-matrix.sh <agent-name>}"

# Get token from environment or 1Password
if [ -z "$MATRIX_TOKEN" ]; then
  if command -v op &> /dev/null && op account get &> /dev/null; then
    MATRIX_TOKEN=$(op item get "${AGENT_NAME} - Matrix" --vault Agents --fields token --reveal 2>/dev/null)
  fi
fi

if [ -z "$MATRIX_TOKEN" ]; then
  echo "ERROR: MATRIX_TOKEN not set and could not fetch from 1Password"
  echo "Usage: MATRIX_TOKEN=xxx ./scripts/setup-matrix.sh <agent-name>"
  exit 1
fi

DOMAIN="ricon.family"
HOMESERVER="https://matrix.ricon.family"

CONFIG_DIR="${HOME}/.config/matrix-commander"

mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/credentials.json" << EOF
{
  "homeserver": "${HOMESERVER}",
  "user_id": "@${AGENT_NAME}:${DOMAIN}",
  "access_token": "${MATRIX_TOKEN}",
  "device_id": "SHIMMER_CI"
}
EOF

echo "Matrix configured for @${AGENT_NAME}:${DOMAIN}"
echo "Config written to ${CONFIG_DIR}/credentials.json"
