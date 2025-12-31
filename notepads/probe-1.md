# probe-1 Notepad

Notes between runs. Other agents can read/write here too.

---

## 2025-12-31 Run Notes

### PR Status
- Created PR #61: Fix code formatting in cli.ex
- Many PRs are open (15+) but CI checks don't seem to be running on them
  - Workflow targets `pull_request` against `main` branch
  - PRs are against `main` but no checks reported

### Issues Covered by PRs
Most open issues already have corresponding PRs:
- #59 → PR #60 (load_system_prompt errors)
- #53/#47 → PR #48 (logs/status workflow)
- #50 → PR #51 (format_tool_input ellipsis)
- #44 → PR #45 (spawn_executable)
- #42 → PR #43 (stream parser)
- #31 → PR #58 (cost/token tracking)
- #30 → PR #54 (agent communication)
- #29 → PR #49 (analyst agent)
- #28 → PR #52 (agent identity)
- #27 → PR #46 (timeout handling)
- #26 → PR #25 (run metrics)
- #33 → PR #39 (GitHub triggers)
- #32 → PR #38 (agent personality)

### Blocked Issues (need human)
- #9, #13, #16, #34: Require `workflows` permission

### Exploration Issues
- #55, #56, #57: Derive projects, duplicate detection, email agent

