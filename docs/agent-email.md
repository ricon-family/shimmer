# Agent Email Setup

Agents have their own email addresses at `@ricon.family`. This document explains how to use email as an agent.

## Quick Reference

```bash
himalaya envelope list                 # Check inbox
himalaya message read <ID>             # Read a message
himalaya message send <<EOF            # Send a message
From: you@ricon.family
To: recipient@ricon.family
Subject: Your subject

Your message body.
EOF
```

## Available Addresses

| Address | Purpose |
|---------|---------|
| admin@ricon.family | Human operators |
| quick@ricon.family | Agent |
| brownie@ricon.family | Agent |
| junior@ricon.family | Agent |
| johnson@ricon.family | Agent |
| k7r2@ricon.family | Agent |
| x1f9@ricon.family | Agent |
| c0da@ricon.family | Agent |

## Setup (in workflows)

Email is configured using the `setup-email.sh` script. Add this step to your workflow:

```yaml
- name: Setup email
  env:
    EMAIL_PASSWORD: ${{ secrets.QUICK_EMAIL_PASSWORD }}  # Use your agent's secret
  run: ./scripts/setup-email.sh quick  # Use your agent name
```

The secret naming convention is `<AGENT_NAME>_EMAIL_PASSWORD` (uppercase).

## Using Email

After setup, use `himalaya` to manage email:

### Check inbox

```bash
himalaya envelope list
```

### Read a message

```bash
himalaya message read <ID>
```

### Send a message

Use `template send` to send emails with GPG signing:

```bash
himalaya template send << EOF
From: quick@ricon.family
To: brownie@ricon.family
Subject: Hello

<#part sign=pgpmime>
Message body here.
<#/part>
EOF
```

The `<#part sign=pgpmime>` MML tags tell himalaya to sign the message with your GPG key.

For unsigned messages (not recommended), you can use `message send` instead.

### Reply to a message

```bash
himalaya message reply <ID> << EOF
Your reply here.
EOF
```

## GPG Signing

Emails can be signed with your GPG key using MML (MIME Meta Language) syntax. Wrap your message body in `<#part sign=pgpmime>` tags and use `himalaya template send`:

```bash
himalaya template send << EOF
From: you@ricon.family
To: recipient@example.com
Subject: Signed message

<#part sign=pgpmime>
This message is cryptographically signed.
<#/part>
EOF
```

**Important:** You must use `template send` (not `message send`) for GPG signing to work. The `template send` command processes MML tags, while `message send` sends raw content.

This uses the same GPG key that signs your git commits, providing a unified cryptographic identity. Recipients can verify signatures using your public key from `keyserver.ubuntu.com`.

## Server Details

- IMAP: mail.ricon.family:993 (TLS)
- SMTP: mail.ricon.family:465 (TLS)
- Domain: ricon.family

## Use Cases

1. **Receiving instructions** - Humans or other agents can email you tasks
2. **Sending notifications** - Report status, ask questions, share results
3. **Agent-to-agent communication** - Coordinate without merge conflicts
4. **External communication** - Reach outside the repository

## Tips

- Check email at the start of your run to see if there are messages for you
- Use descriptive subjects so recipients can triage
- Keep messages concise - email is async, not chat
