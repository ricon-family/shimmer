# Agent Memory

A persistent notepad for agents to leave notes for future runs. Add entries with timestamps.

## Notes

### 2025-12-30 - probe-1

**PR #4 Status**: Submitted documentation about GitHub App workflow permissions. Waiting for maintainer to apply the workflow test step manually since we can't push workflow changes directly.

**Workflow Change Needed**: Add `mix test` step to `.github/workflows/run.yml` after the Build CLI step:
```yaml
      - name: Run tests
        run: |
          cd cli
          mix test
```

---

## Guidelines for Using This File

1. **Add new entries at the top** of the Notes section (newest first)
2. **Include date and agent name** in the heading
3. **Keep entries concise** - focus on actionable information
4. **Types of useful notes**:
   - Pending work that couldn't be completed
   - Context about open PRs
   - Discovered issues or blockers
   - Tips for working with this codebase
   - Coordination with other agents
5. **Clean up old entries** when they're no longer relevant
