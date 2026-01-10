# Research Log

Running log of GitHub documentation reviewed and key takeaways.

## 2026-01-09

### About Issues
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/about-issues

Reviewed foundational concepts for GitHub Issues. This is the entry point for understanding how Issues work before diving into Projects.

Key topics covered:
- Core purpose and use cases
- Sub-issues and dependencies
- Metadata (types, labels, milestones)
- Cross-linking and integrations
- Issues vs Discussions distinction

Detailed notes: [concepts/issues.md](concepts/issues.md)

### Quickstart for Issues
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/quickstart

Practical walkthrough of issue creation. Notable additions:
- Task lists in markdown can be converted to issues later
- Issue types are org-level classification
- Milestones are date-based targets
- Emphasis on descriptive titles that convey purpose at a glance

### Planning and Tracking Work for Your Team or Project
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/planning-and-tracking-work-for-your-team-or-project

Comprehensive planning guide. Major insights:

**Repository types**: Product, Project, Team, Personal - different organizational purposes.

**Work breakdown hierarchy**:
- Issues → Sub-issues → Task lists
- Task lists show completion progress and auto-check when linked issues close

**Labels strategy**: Categorize by project goals, status, work type, severity.

**Project views**: Table (spreadsheet), Board (kanban), Roadmap (timeline).

**Recommended implementation flow**:
1. Create repository with purpose
2. Add README/CONTRIBUTING
3. Define issue templates
4. Decompose work (issues → sub-issues → task lists)
5. Apply labels and dependencies
6. Add to project for visualization
7. Collaborate via comments/updates

**Agent consideration**: Issue templates are designed for web UI presentation. The `gh` CLI does support templates via `gh issue create --template "Template Name"`, but agents would need to explicitly know template names and use the flag. Not automatic like the web picker. May need wrapper tooling or agent prompts to ensure template usage.

### Creating an Issue (CLI section)
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue + `gh issue create --help`

Focused on `gh issue create` for agent workflows:
- Fully non-interactive with flags: `--title`, `--body`, `--assignee`, `--label`, `--project`, `--milestone`
- Multiple values comma-separated (e.g., `--label "bug,help wanted"`)
- Can add to project directly via `--project projectname`
- Use `@me` for self-assignment

Additional flags from `--help`:
- `--body-file file` - Read body from file (`-` for stdin), useful for longer issue descriptions
- `-R OWNER/REPO` - Create issue in different repo
- `--recover` - Recover input from failed run
- Labels can be specified as `--label "a,b"` or `--label a --label b`

This means agents can create fully-configured issues in a single command without prompts.

### Sub-Issues and Issue Dependencies
Sources:
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies

**Sub-issues**:
- Max 100 per parent, up to 8 levels deep
- Can add existing issues as sub-issues (cross-repo supported)
- Integrates with Projects for filtering/grouping
- **CLI**: [gh-sub-issue](https://github.com/yahsan2/gh-sub-issue) extension provides full support - likely important for our workflows

**Dependencies**:
- Two types: "blocked by" and "blocking"
- Visual "Blocked" icon on boards/issues page
- Helps identify bottlenecks
- **CLI**: No maintained extension. [gh-issue-dependency](https://github.com/torynet/gh-issue-dependency) exists but unmaintained - not recommended. Would need GraphQL API for programmatic access.

### Assigning Issues
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/assigning-issues-and-pull-requests-to-other-github-users + `gh issue edit --help`

- Max 10 assignees per issue
- `gh issue edit` supports `--add-assignee` / `--remove-assignee`
- Can bulk edit multiple issues: `gh issue edit 23 34 --add-label "help wanted"`
- Same `@me` shortcut works
- Full edit support: assignees, labels, projects, milestones, title, body

### Editing, Viewing, and Browsing Issues
Sources:
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/editing-an-issue
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/viewing-all-of-your-issues-and-pull-requests
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/browsing-sub-issues

Mostly web UI focused. Key takeaways:
- Edit history preserved for issue descriptions
- Web dashboard: up to 25 saved views with custom searches
- Sub-issue browsing: expand/collapse hierarchies, link to parent in header

For agents, `gh issue list` provides equivalent functionality:
- Filters: `--assignee`, `--author`, `--label`, `--milestone`, `--mention`, `--state`
- Full search: `--search "query"`
- JSON output: `--json fields --jq expr` for scripting
- Many fields available including `projectItems` for project integration

### Filtering and Searching Issues
Source: https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/filtering-and-searching-issues-and-pull-requests

Comprehensive search syntax for `gh issue list --search`:

**Boolean operators**: `AND`, `OR`, parentheses (5 levels), `-` for negation

**Key qualifiers**:
- `author:`, `assignee:`, `involves:`, `label:`, `type:`, `milestone:`
- `linked:pr`, `reason:completed`, `has:label`, `no:project`, `no:assignee`
- PR-specific: `is:draft`, `review:none/approved/changes_requested`, `reviewed-by:`, `is:merged`
- Sorting: `sort:created-asc`, `sort:updated-desc`, `sort:comments-desc`

Examples: `label:bug no:assignee sort:created-asc`, `(type:Bug OR type:Feature) AND no:project`

### Branches and PR Linking
Sources:
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-a-branch-for-an-issue
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue

**Creating branches from issues**: Web UI only (public preview), no CLI support.

**Linking PRs to issues**:
- Auto-close keywords: `close/closes/closed`, `fix/fixes/fixed`, `resolve/resolves/resolved`
- Syntax: `Closes #10`, `Fixes org/repo#100` (cross-repo supported)
- **Critical**: Only works for PRs targeting default branch!
- CLI: Just include keyword in body: `gh pr create --body "Fixes #123"`
- Limit: 10 issues per PR

### Issue Types
Sources:
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization
- https://github.com/cli/cli/issues/9696

**What they are**: Org-level classification (defaults: Task, Bug, Feature). Max 25 per org.

**Best practice**: Use issue types for Bug/Feature/Task classification instead of labels. Labels are for other categorization (priority, area, etc.).

**CLI support**: No native flag yet, but REST API workaround:
```bash
gh api -X PATCH repos/{owner}/{repo}/issues/1234 --field type=Bug
```

Creating/managing issue types is UI only - acceptable since it's infrequent.

### Administering Issues
Sources:
- https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/marking-issues-or-pull-requests-as-a-duplicate
- https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/transferring-an-issue-to-another-repository
- https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/closing-an-issue
- https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/deleting-an-issue
- https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/duplicating-an-issue

| Action | CLI Support | Notes |
|--------|-------------|-------|
| Close | `gh issue close 123 --reason "not planned"` | Reasons: completed, not planned |
| Delete | `gh issue delete 123 --yes` | Requires admin perms |
| Transfer | `gh issue transfer 123 owner/repo` | Same owner only, open issues only, preserves comments/labels/milestones |
| Mark duplicate | Via comment: `gh issue comment 123 --body "Duplicate of #X"` | Creates timeline event |
| Copy/duplicate | No - web UI only | Copies all metadata, cross-repo supported |

### Labels
Source: https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels

**What labels are**: Tags for categorizing issues, PRs, and discussions. Repository-scoped (not shared across repos).

**Default labels** (9 total): bug, documentation, duplicate, enhancement, good first issue, help wanted, invalid, question, wontfix

**Important overlap consideration**: Default labels `bug` and `enhancement` overlap with Issue Types (Bug, Feature). Best practice is to use Issue Types for work classification and labels for other dimensions:
- **Use Issue Types for**: Bug, Feature, Task (what kind of work)
- **Use Labels for**: Priority, area, status, contributor signals, process markers

**Good label patterns** (shimmer examples):
- `priority:high/medium/low` - Priority tier
- `exploration`, `rfc` - Work process markers
- `parking-lot`, `waiting-for-data` - Status/blocking indicators
- `needs-human` - Escalation signal
- `good first issue`, `help wanted` - Contributor onboarding

**CLI support** - Full support via `gh label`:

```bash
# Create label (--force updates if exists)
gh label create "priority:critical" --color FF0000 --description "Urgent issues"

# Edit label (can rename with --name)
gh label edit bug --name "type:bug" --color FF0000
gh label edit "priority:high" --description "Updated description"

# List labels (with search and JSON output)
gh label list --sort name
gh label list --search "priority"
gh label list --json name,description,color

# Delete label
gh label delete "old-label" --yes

# Clone labels between repos (great for standardization!)
gh label clone source-org/source-repo --force
gh label clone org/template-repo -R org/new-repo
```

The `clone` command is particularly useful for establishing consistent label schemes across repositories.

**Permission requirements**:
- Create/edit/delete: Write access
- Apply to issues: Triage access

### Milestones
Sources:
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/creating-and-editing-milestones-for-issues-and-pull-requests
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/associating-milestones-with-issues-and-pull-requests
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/filtering-issues-and-pull-requests-by-milestone
- https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/viewing-your-milestones-progress

**What milestones are**: Date-driven groupings for issues/PRs toward a goal (releases, sprints). Repository-scoped.

**Key features**:
- Title, description (Markdown), due date
- Progress tracking (open/closed counts, percentage)
- Prioritization within milestone (drag to reorder, limit 500 open issues)

**CLI support**:
- **Associating**: Full support via `gh issue create --milestone`, `gh issue edit --milestone`, `gh issue list --milestone`
- **Managing (create/edit/delete)**: No `gh milestone` command - requires API calls

**CLI gap resources** (for future investigation):
- gh-milestone extension (unmaintained): https://github.com/valeriobelli/gh-milestone
- Alias examples: https://gist.github.com/doi-t/5735f9f0f7f8b7664aa6739bc810a2cc

**Milestones vs Projects**: Milestones are simpler, date-driven, single-repo. Projects are flexible, cross-repo, with custom fields. Can use together.
