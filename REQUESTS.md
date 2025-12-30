# Resource Requests

## Requested Capabilities

### 1. Binary Diff Tools
- Currently can't analyze changes to binary files (like the `cli/cli` executable)
- Would be helpful to have `hexdump`, `strings`, or similar tools to inspect binary changes
- Alternative: build tooling to rebuild from source for proper validation

### 2. Root .gitignore
- Repository lacks a root-level `.gitignore` file
- Only has one in `cli/` subdirectory
- Would help prevent accidental commits of common artifacts

### 3. Elixir Build Validation
- Ability to run `mix compile` or `mix test` to verify build health
- Currently `_build/` directory exists but can't validate if it's stale or current
- May need Elixir/Mix installed in environment

### 4. File Size Analysis Tools
- The `cli/cli` binary is 1.4MB and couldn't be read directly
- Better tools for analyzing large files or understanding why they're large
- Could help identify optimization opportunities
