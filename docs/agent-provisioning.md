# Agent Provisioning

This document describes how to provision a new agent with a full identity.

## Prerequisites

- Access to `admin@ricon.family` GPG key (org signing key)
- Access to email provider to create accounts
- GitHub account with org admin access

## Quick Start

For agents that already have email accounts:

```bash
mise run provision-agent <agent-name> [--force]
```

This will:
1. Generate a GPG key (or use existing)
2. Sign it with the org key
3. Store keys as GitHub secrets

## Full Provisioning Steps

### 1. Create Email Account

Create an email account at the email provider:
- Email: `<agent>@ricon.family`
- Store password securely

Add the password as a GitHub secret:
```bash
gh secret set <AGENT>_EMAIL_PASSWORD
```

### 2. Generate and Sign GPG Key

Run the provisioning task:
```bash
mise run provision-agent <agent-name>
```

This creates:
- `<AGENT>_GPG_PRIVATE_KEY` - for signing commits
- `<AGENT>_GPG_PUBLIC_KEY` - for verification

### 3. Create GitHub Account

1. Go to https://github.com/join
2. Use `<agent>@ricon.family` as the email
3. Username: `<agent>-ricon` or similar
4. Verify email

### 4. Upload GPG Key to GitHub

1. Export the public key:
   ```bash
   gpg --armor --export <agent>@ricon.family
   ```
2. Go to GitHub → Settings → SSH and GPG keys → New GPG key
3. Paste the public key

### 5. Generate PAT

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens
2. Create token with:
   - Repository access: `ricon-family/shimmer`
   - Permissions: `Contents: Read and write`, `Workflows: Read and write`
3. Store as secret:
   ```bash
   gh secret set <AGENT>_GITHUB_PAT
   ```

### 6. Add to Organization

1. Go to https://github.com/orgs/ricon-family/people
2. Invite the agent's GitHub account
3. Grant appropriate permissions

## Trust Chain

All agent keys are signed by the org key, which is signed by the org admin:

```
rikonor@gmail.com (personal)
    └── signs → admin@ricon.family (org)
                    └── signs → <agent>@ricon.family
```

This proves:
- The org admin authorized the agent
- The agent belongs to ricon.family

## Workflow Integration

Add these steps to agent workflows:

```yaml
- name: Setup email
  env:
    EMAIL_PASSWORD: ${{ secrets.<AGENT>_EMAIL_PASSWORD }}
  run: ./scripts/setup-email.sh <agent>

- name: Setup GPG
  env:
    GPG_PRIVATE_KEY: ${{ secrets.<AGENT>_GPG_PRIVATE_KEY }}
  run: ./scripts/setup-gpg.sh <agent>
```

## Secrets Reference

Each agent should have these secrets:

| Secret | Purpose |
|--------|---------|
| `<AGENT>_EMAIL_PASSWORD` | Email account access |
| `<AGENT>_GPG_PRIVATE_KEY` | Commit signing |
| `<AGENT>_GPG_PUBLIC_KEY` | Key verification |
| `<AGENT>_GITHUB_PAT` | GitHub API access with workflow permissions |

## Current Agents

| Agent | Email | GPG | GitHub | PAT |
|-------|-------|-----|--------|-----|
| quick | ✅ | ✅ | ⬜ | ⬜ |
| brownie | ✅ | ✅ | ⬜ | ⬜ |
| junior | ✅ | ✅ | ⬜ | ⬜ |
| johnson | ✅ | ✅ | ⬜ | ⬜ |
| k7r2 | ✅ | ✅ | ⬜ | ⬜ |
| x1f9 | ✅ | ✅ | ⬜ | ⬜ |
| c0da | ✅ | ✅ | ⬜ | ⬜ |
