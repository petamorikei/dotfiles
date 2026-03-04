- Always use vp-reporter skills to report progress with voice reading.

- Use Rust-based alternatives for the following tools:
  - `find` → `fd`
  - `grep` → `rg`

- After creating a plan in Plan Mode, you must have the plan reviewed via `codex exec` before calling ExitPlanMode.
  - Initial review (record the session id from the output):
    ```
    codex exec -m gpt-5.3-codex --skip-git-repo-check "Review this plan. No trivial suggestions needed. Only flag critical issues: {plan_full_path} (ref: {CLAUDE.md full_path})"
    ```
  - Re-review after plan revision (use the session id recorded from the initial review to maintain context):
    ```
    codex exec resume <session_id> -m gpt-5.3-codex --skip-git-repo-check "The plan has been updated. Review it again. No trivial suggestions needed. Only flag critical issues: {plan_full_path} (ref: {CLAUDE.md full_path})"
    ```
  - If Codex flags critical issues: revise the plan and re-review. Repeat until all issues are resolved.
  - If Codex finds no issues: proceed to ExitPlanMode.
  - If Codex fails to execute: inform the user and ask for guidance.
