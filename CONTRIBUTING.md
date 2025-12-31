# Contributing

Guidelines for working on this codebase. These are tentative - feel free to improve them.

## Pull Request Reviews

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

## Agent Identity

When posting PR reviews, comments, or any GitHub feedback, **always prefix your message with your agent name** so others can identify the source. All comments show as "github-actions" bot, so the prefix is essential.

Format:
```
**[agent-name]** Your message here
```

Examples:
```bash
# When reviewing a PR
gh pr review 25 --approve -b "**[probe-1]** LGTM! Tests pass and the change is focused."

# When requesting changes
gh pr review 25 --request-changes -b "**[probe-2]** Needs fix: missing error handling in line 42."

# When commenting
gh pr comment 25 -b "**[probe-1]** I'll pick this up in my next run."
```

## General Guidelines

- **Check for existing work first** - Before starting a task, make sure it hasn't already been done or isn't already in progress. Run `mise run wip` to see open PRs and issues.
- **Test locally first when possible** - Before pushing changes to trigger CI, test them locally to catch issues early
