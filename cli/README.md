# Cli

Elixir escript for invoking Claude Code agents via GitHub Actions.

## Overview

This CLI handles the orchestration of Claude Code agent runs, including:
- Argument parsing and validation
- System prompt loading (common + agent-specific prompts)
- Claude Code invocation with streaming JSON output
- Real-time display of tool calls and text responses
- Timeout management for CI environments

## Usage

```bash
# Build the escript
mix escript.build

# Run an agent
./cli --agent probe-1 "Your message here"

# Run with context logging (requires claude-code-logger)
./cli --agent probe-1 --log-context "Your message here"
```

## Options

| Option | Description |
|--------|-------------|
| `--agent <name>` | Required. Agent name (loads `cli/lib/prompts/agents/<name>.txt`) |
| `--log-context` | Enable request/response logging via claude-code-logger proxy |

## System Prompts

Prompts are loaded from `cli/lib/prompts/`:

- `common.txt` - Shared instructions for all agents
- `agents/<name>.txt` - Agent-specific instructions

Both are concatenated when invoking Claude Code.

## Timeout

The CLI enforces a 9-minute timeout (configurable via `@timeout_seconds`), leaving buffer room before GitHub Actions' 10-minute job timeout.
