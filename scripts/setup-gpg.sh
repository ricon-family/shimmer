#!/bin/bash
# Setup GPG signing for an agent in CI
#
# Usage: GPG_PRIVATE_KEY=xxx ./scripts/setup-gpg.sh <agent-name>
# Example: GPG_PRIVATE_KEY=$QUICK_GPG_PRIVATE_KEY ./scripts/setup-gpg.sh quick
#
# Imports the agent's GPG key and configures git to use it for signing.

set -e

AGENT_NAME="${1:?Usage: setup-gpg.sh <agent-name>}"
GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY:?GPG_PRIVATE_KEY environment variable required}"

# Verify gpg is available
if ! command -v gpg &> /dev/null; then
  echo "ERROR: gpg command not found. Please install GnuPG."
  exit 1
fi

EMAIL="${AGENT_NAME}@ricon.family"

# Import the private key
echo "$GPG_PRIVATE_KEY" | gpg --batch --import 2>/dev/null

# Get the key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$EMAIL" 2>/dev/null | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)

if [ -z "$KEY_ID" ]; then
  echo "ERROR: Could not find key ID for $EMAIL"
  exit 1
fi

# Configure git to use this key for signing
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# Trust the key (so gpg doesn't complain about untrusted key)
echo -e "5\ny\n" | gpg --batch --command-fd 0 --expert --edit-key "$EMAIL" trust quit 2>/dev/null || true

echo "GPG configured for $EMAIL (key: $KEY_ID)"
