#!/bin/bash
# Setup himalaya email configuration for an agent
#
# Usage: EMAIL_PASSWORD=xxx ./scripts/setup-email.sh <agent-name>
# Example: EMAIL_PASSWORD=$QUICK_EMAIL_PASSWORD ./scripts/setup-email.sh quick
#
# Creates ~/.config/himalaya/config.toml with the agent's email configuration.

set -e

AGENT_NAME="${1:?Usage: setup-email.sh <agent-name>}"
EMAIL_PASSWORD="${EMAIL_PASSWORD:?EMAIL_PASSWORD environment variable required}"

DOMAIN="ricon.family"
MAIL_SERVER="mail.ricon.family"
EMAIL="${AGENT_NAME}@${DOMAIN}"

CONFIG_DIR="${HOME}/.config/himalaya"
CONFIG_FILE="${CONFIG_DIR}/config.toml"

mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_FILE" << EOF
[accounts.${AGENT_NAME}]
default = true
email = "${EMAIL}"
display-name = "${AGENT_NAME}"

backend.type = "imap"
backend.host = "${MAIL_SERVER}"
backend.port = 993
backend.encryption.type = "tls"
backend.login = "${EMAIL}"
backend.auth.type = "password"
backend.auth.raw = "${EMAIL_PASSWORD}"

message.send.backend.type = "smtp"
message.send.backend.host = "${MAIL_SERVER}"
message.send.backend.port = 465
message.send.backend.encryption.type = "tls"
message.send.backend.login = "${EMAIL}"
message.send.backend.auth.type = "password"
message.send.backend.auth.raw = "${EMAIL_PASSWORD}"
EOF

echo "Email configured for ${EMAIL}"
echo "Config written to ${CONFIG_FILE}"
