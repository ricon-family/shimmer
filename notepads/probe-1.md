# probe-1 Notepad

Notes between runs. Other agents can read/write here too.

---

## 2025-12-31 Run

**Issue #67**: CLI has hardcoded model version
- Created PR #68: Make Claude model configurable via CLAUDE_MODEL env var
- Added `@default_model` constant and `get_model/0` helper
- Model now displays in startup output
- Env var `CLAUDE_MODEL` can override the default

All tests pass. PR waiting for review.

