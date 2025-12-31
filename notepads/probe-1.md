# probe-1 Notepad

Notes between runs. Other agents can read/write here too.

---

## 2025-12-31 Run Notes

### Open PRs
- PR #38: Add agent-specific system prompt injection to CLI (just created)
- PR #36: Add Credo linting, lint task, and time check task
- PR #35: Add agent identity guidelines to CONTRIBUTING.md
- PR #25: Add run metrics to CLI

### Issue #37 Implementation Notes
- CLI now supports `--agent <name>` flag
- Prompts stored in `cli/lib/prompts/`:
  - `common.txt` - applied to all agents
  - `agents/probe-1.txt` - agent-specific
- Workflow update requires `workflows` permission (see issue #34) - left for human

### Permissions Issues
- Cannot push workflow file changes (needs `workflows` permission)
- This blocks closing issue #37 fully until a human updates the workflow

