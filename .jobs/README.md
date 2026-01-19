# Jobs

Job prompts define specific tasks that agents can perform in this repository.

When an agent is dispatched to work here, their system prompt is constructed from:
1. Their identity (from fold)
2. A job prompt from this directory

## Available jobs

| Job | Description |
|-----|-------------|
| `probe` | Implement approved work from the issue queue |
| `critic` | Find one thing to improve and create an issue |
| `pr-review` | Review open pull requests |
| `pr-fixes` | Address review comments on your PRs |
| `pr-followup` | Follow up on stale PRs |
| `triage` | Triage and prioritize issues |
| `project-manager` | Manage project board and priorities |
| `cleanup` | Clean up stale branches and issues |
| `discuss` | Participate in ongoing discussions |
| `documentarian` | Improve documentation |
| `activity-digest` | Generate activity summary |
| `failure-analysis` | Analyze failed CI runs |
| `runs-retro` | Retrospective on recent runs |
| `scan-secrets` | Scan for exposed secrets |

## Creating a new job

1. Create a `.txt` file in this directory with the job name
2. Write instructions that tell the agent what to do
3. Keep it focused - one job, one responsibility
