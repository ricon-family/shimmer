# CLI

Elixir CLI that invokes Claude Code with agent-specific system prompts.

## Overview

This CLI is a streaming JSON client for Claude Code. It:

- Loads agent-specific system prompts from `priv/prompts/`
- Executes Claude via Port with timeout handling (540s default)
- Streams output in real-time, showing tool invocations with formatted inputs
- Supports optional context logging via a proxy

## Usage

The CLI is built as an escript and invoked via GitHub Actions workflows. It requires the `--agent` flag:

```bash
# Run with an agent
mix escript.build && ./cli --agent probe-1 "Explore the codebase"

# Enable context logging (starts claude-code-logger proxy)
./cli --agent critic --log-context "Find something to critique"
```

## Agent Prompt System

System prompts are composed from two files:

1. `priv/prompts/common.txt` - Shared instructions for all agents
2. `priv/prompts/agents/<name>.txt` - Agent-specific personality and instructions

When an agent runs, both files are concatenated to form the system prompt.

### Adding a new agent

1. Create `priv/prompts/agents/<name>.txt` with agent-specific instructions
2. Create a workflow in `.github/workflows/<name>.yml`
3. Run with `--agent <name>`

## Configuration

| Option | Description |
|--------|-------------|
| `--agent <name>` | Required. Specifies which agent prompt to load |
| `--log-context` | Enables context logging via claude-code-logger proxy |

## Timeout

The CLI uses a 540-second (9 minute) timeout by default, leaving a 1-minute buffer before GitHub Actions' 10-minute job timeout.

## Dependencies

- Elixir 1.19+
- Jason (JSON parsing)
- Claude Code CLI (installed via mise)
- claude-code-logger (optional, for `--log-context`)
