#!/usr/bin/env bash
# Claude Code PreToolUse(Bash) hook: keeps gh on the GitHub account that the
# directory's mise config names.
#
# ~/Workspace/.mise/conf.d/gh-account.toml (and, on work machines, the same
# file in the work directory) sets GH_TOKEN to an account's token, so
# interactive shells use that account
# whatever `gh auth switch` last chose. Claude Code's shell does not run mise's
# prompt hook, so that GH_TOKEN never reaches it. This hook compares the token
# the directory names with the active account's token, and when they differ,
# stops the command and asks for it to be rerun as `mise exec -- gh ...`.
# It never switches the account itself.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

# Only commands that still run gh outside `mise exec -- gh`.
rest=${cmd//mise exec -- gh/MISE_EXEC_GH}
printf '%s' "$rest" | rg -q '(^|[;&|(`\s])gh\s' || exit 0

command -v mise >/dev/null 2>&1 || exit 0
[ -n "$cwd" ] || cwd=$PWD

# The token the directory's mise config names. Untrusted or absent configs
# give nothing, and then there is nothing to check.
want=$(cd "$cwd" 2>/dev/null && mise env --json 2>/dev/null | jq -r '.GH_TOKEN // empty')
[ -n "$want" ] || exit 0

# What gh would use here: a GH_TOKEN this session inherited (say, from a
# shell in another directory tree), or else the active account's token.
have=$(gh auth token 2>/dev/null)
[ "$want" = "$have" ] && exit 0

reason="このディレクトリのmise設定（GH_TOKEN）は、ghのアクティブアカウントとは別のアカウントを指定しています。同じコマンドを「mise exec -- gh ...」の形にして実行し直してください（ghの部分すべてに付けること）。gh auth switchでアカウントを切り替えないこと。"

jq -n --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $r
  }
}'
exit 0
