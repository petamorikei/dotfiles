# Linear workflow

A repository opts into this workflow by importing this file from its
CLAUDE.md (`@~/.claude/linear-workflow.md`). Repositories that do not import
it do not use it.

## Scope

- Linear workspace: Petamori, through the Linear MCP server (`linear-server`).
- Team: always `DEV`. Never read or write the `LIFE` team (personal daily
  tasks) unless the user explicitly asks.
- Project: the `DEV` project named after the repository. Take the repository
  name from `git remote get-url origin` (the last path segment without
  `.git`), not from `gh`. If no such project exists, ask the user whether to
  create it or to go on without a project.

## Starting work

- Given an issue ID, read the issue's description, comments, and related
  issues through MCP before starting.
- Ask the user about anything unclear before implementing.

## Branches

- Every branch name contains the issue ID. Use the issue's `gitBranchName`
  (the same format as Linear's "Copy git branch name"), e.g.
  `petamorikei/dev-123-fix-login`.
- When the title is Japanese, `gitBranchName` contains Japanese: use
  `petamorikei/dev-<number>-<short English description>` instead, ASCII only
  (e.g. `petamorikei/dev-1-update-claude-md`). The ID alone links the branch.
- Never commit directly to the default branch.

## Commits

- Include the issue ID in the message (e.g. `DEV-123: ログイン処理のバリデーションを修正`).
- No magic words such as `Fixes` in commit messages: status changes are left
  to the PR.

## Pull requests

- Put the issue ID with a magic word in the PR body:
  - `Fixes DEV-123` when the PR completes the issue.
  - `Refs DEV-123` for partial work (the issue stays open).
- Open the PR as a draft while working; when the implementation is done, mark
  it ready with `gh pr ready`.
- Target the default branch.
- The user reviews the PR. Merge only after the user explicitly approves, with
  `gh pr merge --merge --delete-branch`. Never merge without approval.
- After merging, confirm through MCP that the issue is Done, and bring the
  local default branch up to date (`git fetch --prune`).

## Status flow (the `DEV` team's PR automations)

| PR event | Issue status |
|---|---|
| Draft PR opened | In Progress |
| PR opened / marked ready for review | In Review |
| Review requested / review activity | In Review |
| Merged | Done |

## Linear operations

- Leave statuses to the automations above; do not change them through MCP.
- Ask the user before creating, changing the status of, or deleting an issue
  through MCP.
- Show the user any comment (work summary, reasoning) before posting it to an
  issue.

## gh

- If the gh-account-guard hook stops a gh command, run the same command again
  as `mise exec -- gh ...` (prefix every gh in it). Never run
  `gh auth switch`.
