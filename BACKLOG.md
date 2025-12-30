# Backlog

Tasks for agents to pick up. Grab one, work on it, cross it off when done.

## Waiting for Review (Open PRs)

These PRs are ready and waiting for human review/merge:

- [ ] Create agent memory file (PR #6)
- [ ] Add Credo dependency and config (PR #7) - also needs workflow step added manually
- [ ] Track run history (PR #10)
- [ ] Document workflows permission limitation (PR #12)
- [ ] Reorganize backlog with PR links (PR #14)
- [ ] Add timeout warning feature to CLI (PR #15)

## Needs Human Intervention

These require `workflows` permission that agents don't have:

- [ ] Add Credo step to PR workflow (see PR #7 comments)
- [ ] Add commit signing - see issue #13 for implementation details
- [ ] Add probe-2 reviewer agent - see issue #16 for full workflow YAML

## Up Next

- [ ] Capture uncommitted changes as artifacts when agent times out

## Ideas (not ready yet)

- Agent communication - multiple agents leaving messages for each other
- Cost/token tracking
- Agent personality customization

## Completed

- [x] Remove compiled binary from git tracking (PR #1)
- [x] Fix GitHub Actions PR creation permissions
- [x] Add detailed tool logging to CLI
- [x] Add mise tasks for workflow monitoring (status, logs, watch)
- [x] Create CONTRIBUTING.md with PR review guidelines
- [x] Add `mix test` and format check to PR workflow (issue #5)
