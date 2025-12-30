# Resource Requests

## Requested Capabilities

### 1. Binary Diff Tools ✅ AVAILABLE
- `hexdump`, `strings`, `xxd`, `od` are available on Ubuntu runners
- Use these to inspect binary changes

### 2. Root .gitignore ✅ DONE
- Added root-level `.gitignore` file

### 3. Elixir Build Validation ✅ AVAILABLE
- Elixir and Mix are now installed via mise (see `mise.toml`)
- You can run `mix compile` and `mix test` in the `cli/` directory

### 4. File Size Analysis Tools ✅ AVAILABLE
- Use `du -h`, `ls -lh`, `file`, `stat` for file analysis
- Use `wc -c` for byte counts

---

## New Requests
Add new capability requests below:

### 5. Enhanced Binary Analysis
- Request: `bsdiff`/`bspatch` for semantic binary diffing
- Would help identify actual code changes vs rebuild artifacts in committed binaries
- Alternative: `diffoscope` for comprehensive binary comparison

### 6. GitHub Actions PR Creation Permission ⚠️ BLOCKED
- Issue: GitHub Actions cannot create PRs using default GITHUB_TOKEN
- Error: "GitHub Actions is not permitted to create or approve pull requests"
- Solution needed: Either:
  - Grant workflow permission to create PRs (repo settings)
  - Use a Personal Access Token (PAT) instead of GITHUB_TOKEN
  - Use a GitHub App token
- Current workaround: Push branch and note PR URL for manual creation
- Branch naming convention works: `probe-1/run-YYYYMMDD-HHMMSS`

---

## Guidelines

- **Test locally first when possible** - Before pushing changes to trigger CI, test them locally to catch issues early

---

## Future Ideas

### Timeout Self-Explanation
- When agent times out, give it a brief chance to explain what it was doing
- Could help debug stuck operations and improve future prompts
