#!/bin/bash
# Setup himalaya email configuration for an agent
#
# Usage: EMAIL_PASSWORD=xxx ./scripts/setup-email.sh <agent-name>
# Example: EMAIL_PASSWORD=$QUICK_EMAIL_PASSWORD ./scripts/setup-email.sh quick
#
# Creates ~/.config/himalaya/config.toml with the agent's email configuration.
# GPG signing is enabled - run setup-gpg.sh first to import the agent's key.

set -e

AGENT_NAME="${1:?Usage: setup-email.sh <agent-name>}"

# Get password from environment or 1Password
if [ -z "$EMAIL_PASSWORD" ]; then
  if command -v op &> /dev/null && op account get &> /dev/null; then
    EMAIL_PASSWORD=$(op item get "${AGENT_NAME} - Email" --vault Agents --fields password --reveal 2>/dev/null)
  fi
fi

if [ -z "$EMAIL_PASSWORD" ]; then
  echo "ERROR: EMAIL_PASSWORD not set and could not fetch from 1Password"
  echo "Usage: EMAIL_PASSWORD=xxx ./scripts/setup-email.sh <agent-name>"
  exit 1
fi

DOMAIN="ricon.family"
MAIL_SERVER="mail.ricon.family"
EMAIL="${AGENT_NAME}@${DOMAIN}"

CONFIG_DIR="${HOME}/.config/himalaya"
CONFIG_FILE="${CONFIG_DIR}/config.toml"

mkdir -p "$CONFIG_DIR"

# Escape password for TOML basic string: backslash first, then quotes
ESCAPED_PASSWORD=$(printf '%s' "$EMAIL_PASSWORD" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Write config using printf for the password to avoid shell expansion issues
# (heredocs expand $, `, and \ which are common in generated passwords)
{
  printf '[accounts.%s]\n' "$AGENT_NAME"
  printf 'default = true\n'
  printf 'email = "%s"\n' "$EMAIL"
  printf 'display-name = "%s"\n' "$AGENT_NAME"
  printf '\n'
  printf 'backend.type = "imap"\n'
  printf 'backend.host = "%s"\n' "$MAIL_SERVER"
  printf 'backend.port = 993\n'
  printf 'backend.encryption.type = "tls"\n'
  printf 'backend.login = "%s"\n' "$EMAIL"
  printf 'backend.auth.type = "password"\n'
  printf 'backend.auth.raw = "%s"\n' "$ESCAPED_PASSWORD"
  printf '\n'
  printf 'message.send.backend.type = "smtp"\n'
  printf 'message.send.backend.host = "%s"\n' "$MAIL_SERVER"
  printf 'message.send.backend.port = 465\n'
  printf 'message.send.backend.encryption.type = "tls"\n'
  printf 'message.send.backend.login = "%s"\n' "$EMAIL"
  printf 'message.send.backend.auth.type = "password"\n'
  printf 'message.send.backend.auth.raw = "%s"\n' "$ESCAPED_PASSWORD"
  printf '\n'
  printf 'pgp.type = "commands"\n'
  printf 'pgp.sign-cmd = "gpg --sign --quiet --armor"\n'
  printf 'pgp.decrypt-cmd = "gpg --decrypt --quiet"\n'
  printf 'pgp.verify-cmd = "gpg --verify --quiet"\n'
} > "$CONFIG_FILE"

echo "Email configured for ${EMAIL} (GPG signing enabled)"
echo "Config written to ${CONFIG_FILE}"
