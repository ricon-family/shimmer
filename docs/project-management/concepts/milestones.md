# GitHub Milestones

## Overview

Milestones track progress on groups of issues or pull requests toward a goal. They're repository-scoped and useful for release planning, sprints, or deadline-driven work.

Sources:
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/creating-and-editing-milestones-for-issues-and-pull-requests

## Key Features

- **Title, description, due date** - Description supports Markdown
- **Progress tracking** - Shows open/closed counts and completion percentage
- **Prioritization** - Can drag to reorder items within a milestone (limit: 500 open issues)
- **Applies to both issues and PRs**

## Milestone Lifecycle

- Creating/editing: Web UI only (or API)
- Deleting: Issues/PRs are unaffected, just lose the milestone association
- Transfer: When issues transfer repos, milestones transfer if destination has matching name+due date

## CLI Support

**No dedicated `gh milestone` command** - milestone management requires API calls.

### Associating milestones (well supported)

```bash
# Create issue with milestone
gh issue create --title "Task" --milestone "v1.0"

# Add milestone to existing issue
gh issue edit 123 --milestone "v1.0"

# Remove milestone
gh issue edit 123 --remove-milestone

# Filter by milestone
gh issue list --milestone "v1.0"
gh issue list --search "milestone:\"v1.0\""

# PRs also support milestones
gh pr create --title "Feature" --milestone "v1.0"
```

### Managing milestones (API required)

```bash
# List milestones
gh api repos/{owner}/{repo}/milestones

# Create milestone
gh api repos/{owner}/{repo}/milestones -f title="v1.0" -f due_on="2024-03-01T00:00:00Z" -f description="First release"

# Update milestone
gh api repos/{owner}/{repo}/milestones/1 -X PATCH -f title="v1.0.1"

# Close milestone
gh api repos/{owner}/{repo}/milestones/1 -X PATCH -f state=closed

# Delete milestone
gh api repos/{owner}/{repo}/milestones/1 -X DELETE
```

### Future investigation

CLI gap could be addressed by:
- **gh-milestone extension** (unmaintained): https://github.com/valeriobelli/gh-milestone
- **Alias examples**: https://gist.github.com/doi-t/5735f9f0f7f8b7664aa6739bc810a2cc

Worth revisiting if milestone management becomes frequent.

## Filtering

```bash
# By milestone name
gh issue list --milestone "v1.0"

# Search syntax
gh issue list --search "milestone:\"v1.0\""

# Issues without milestone
gh issue list --search "no:milestone"
```

## Milestones vs Projects

| Milestones | Projects |
|------------|----------|
| Date-driven, single repo | Flexible, cross-repo |
| Simple progress tracking | Custom fields, views, workflows |
| Good for releases/sprints | Good for ongoing work organization |

Both can be used together - milestones for time-boxed goals, projects for broader organization.
