# GitHub Labels

## Overview

Labels are tags for categorizing issues, pull requests, and discussions. They're **repository-scoped** - each repo has its own independent set of labels.

Source: https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels

## Labels vs Issue Types

GitHub now has both labels and issue types, creating potential overlap.

**Default labels** include `bug` and `enhancement`, which overlap with Issue Types (Bug, Feature).

**Recommendation**: Use Issue Types for work classification, use labels for orthogonal dimensions:

| Use Issue Types for | Use Labels for |
|---------------------|----------------|
| Bug, Feature, Task (what kind of work) | Priority (`priority:high/medium/low`) |
| | Area/component (`frontend`, `api`, `docs`) |
| | Process markers (`rfc`, `exploration`) |
| | Status indicators (`parking-lot`, `waiting-for-data`) |
| | Contributor signals (`good first issue`, `help wanted`) |
| | Escalation (`needs-human`) |

Consider removing or renaming `bug` and `enhancement` labels if using Issue Types to avoid confusion.

## Default Labels

GitHub creates 9 default labels in new repositories:

| Label | Purpose |
|-------|---------|
| `bug` | Something isn't working |
| `documentation` | Documentation improvements |
| `duplicate` | Already exists |
| `enhancement` | New feature or request |
| `good first issue` | Good for newcomers (populates contribute page) |
| `help wanted` | Maintainer needs assistance |
| `invalid` | Not relevant |
| `question` | Needs more information |
| `wontfix` | Won't be worked on |

Organization owners can customize default labels for all new repos in the org.

## Label Strategy

Labels enable filtering to find related work. Good patterns:

**Priority tiers** (mutually exclusive):
- `priority:high`, `priority:medium`, `priority:low`

**Area/component** (can combine):
- `frontend`, `backend`, `api`, `docs`, `ci`

**Process markers**:
- `rfc` - Request for comments, needs discussion
- `exploration` - Research task
- `run-review` - Post-run analysis

**Status indicators**:
- `parking-lot` - Valid but not current priority
- `waiting-for-data` - Blocked pending data
- `needs-human` - Requires human intervention

**Contributor onboarding**:
- `good first issue` - Entry point for new contributors
- `help wanted` - Open for community contribution

## CLI Commands

Full CLI support via `gh label`:

### Create Label

```bash
gh label create "priority:critical" --color FF0000 --description "Urgent issues"

# Update existing label with --force
gh label create "bug" --color FF0000 --description "Updated" --force
```

### Edit Label

```bash
# Change color
gh label edit bug --color FF0000

# Rename (useful for migrating from labels to issue types)
gh label edit bug --name "legacy:bug"

# Update description
gh label edit "priority:high" --description "Should be worked on next"
```

### List Labels

```bash
# List all (sorted by creation date by default)
gh label list

# Sort by name
gh label list --sort name

# Search label names and descriptions
gh label list --search "priority"

# JSON output for scripting
gh label list --json name,description,color
gh label list --json name,color --jq '.[] | "\(.name): #\(.color)"'
```

JSON fields: `color`, `createdAt`, `description`, `id`, `isDefault`, `name`, `updatedAt`, `url`

### Delete Label

```bash
gh label delete "old-label" --yes
```

Note: Deleting removes the label from all issues/PRs that have it.

### Clone Labels Between Repos

Useful for standardizing labels across repositories:

```bash
# Clone labels from another repo into current repo
gh label clone source-org/source-repo

# Overwrite existing labels with --force
gh label clone source-org/source-repo --force

# Clone into a specific destination repo
gh label clone org/template-repo -R org/new-repo
```

Labels that already exist in destination are skipped unless `--force` is used. Labels in destination that don't exist in source are kept (not deleted).

## Permission Requirements

- **Create/edit/delete labels**: Write access to repository
- **Apply labels to issues/PRs**: Triage access to repository

## Shimmer Current Labels

Beyond defaults, shimmer has:

| Label | Purpose |
|-------|---------|
| `priority:high` | Should be worked on next |
| `priority:medium` | Important but not urgent |
| `priority:low` | Nice to have |
| `exploration` | Research or exploration task |
| `rfc` | Request for comments |
| `parking-lot` | Valid but not current priority |
| `waiting-for-data` | Blocked pending data collection |
| `needs-human` | Requires human intervention |
| `run-review` | Post-run analysis and learnings |

## Open Questions

- Should we rename/remove `bug` and `enhancement` to avoid overlap with Issue Types?
- What area/component labels would be useful for shimmer?
- Should we establish a standard label set for all ricon-family repos?
