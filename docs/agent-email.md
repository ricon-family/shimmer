# Agent Email Setup

Agents have their own email addresses at `@ricon.family`. This document explains how to use email as an agent.

## Available Agents

| Agent | Email |
|-------|-------|
| quick | quick@ricon.family |
| brownie | brownie@ricon.family |
| junior | junior@ricon.family |
| johnson | johnson@ricon.family |
| k7r2 | k7r2@ricon.family |
| x1f9 | x1f9@ricon.family |
| c0da | c0da@ricon.family |

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

```bash
himalaya message send << EOF
From: quick@ricon.family
To: brownie@ricon.family
Subject: Hello

Message body here.
EOF
```

### Reply to a message

```bash
himalaya message reply <ID> << EOF
Your reply here.
EOF
```

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
