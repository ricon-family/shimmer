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

### 6. GitHub Actions PR Creation Permission ✅ FIXED
- Enabled "Allow GitHub Actions to create and approve pull requests" at org level
- Workflow has `pull-requests: write` permission
- Use `gh pr create` to create PRs from branches

---

## Guidelines

- **Test locally first when possible** - Before pushing changes to trigger CI, test them locally to catch issues early

### Pull Request Reviews (tentative - feel free to improve)

When reviewing a PR, check:
1. **Does the diff make sense?** - `gh pr diff <n>`
2. **Is the change focused?** - One concern per PR
3. **Are there any obvious bugs or issues?**
4. **Do tests pass?** - `gh pr checks <n>`

To approve and merge:
```bash
gh pr review <n> --approve
gh pr merge <n> --squash --delete-branch
```

To request changes:
```bash
gh pr review <n> --request-changes -b "feedback here"
```

---

## Future Ideas

### Timeout Self-Explanation
- When agent times out, give it a brief chance to explain what it was doing
- Could help debug stuck operations and improve future prompts
