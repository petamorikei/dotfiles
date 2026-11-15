# dotfiles

My machine setup managed with [mise](https://mise.jdx.dev/): packages, tools,
dotfiles, and macOS settings, applied with `mise bootstrap`. This repository is
mise's global config and lives at `~/.config/mise`.

New machines are set up by kickstart (a separate, private repository), which
detects the machine, writes its env list, and runs `mise bootstrap` around the
steps mise cannot do (logins, drivers, reboot).

## Day-to-day

```bash
export BW_SESSION=$(bw unlock --raw)
mise run apply        # git pull --ff-only, then fnox exec -- mise bootstrap, from any directory
```

`mise run apply` pulls this repository first, so changes pushed from other
machines are applied too (plain `mise bootstrap` does not pull). When this
checkout has diverged from upstream, the pull stops the task: merge or rebase
by hand, then run it again. Pushing stays manual.

On machines with the `secrets` env, use `mise run apply`: plain
`mise bootstrap` stops because the secret templates have no values.

Files under `home/` are symlinked into `~`, so edits to them land here
directly (a new file directly under `home/`, outside `.config`, needs its own
entry in `config.toml`). Templates under `templates/` and copies under `files/` are written on
apply: edit the source here, then apply.

## Layout

| Path | Loaded |
|---|---|
| `config.toml` | Always |
| `config.macos.toml`, `config.linux.toml` | By platform (`auto_env` in `miserc.toml`) |
| `config.<env>.toml` | When the env is in `miserc.local.toml` (written by kickstart, not committed) |
| `Brewfile` | macOS, by the `post-packages` hook (real Homebrew, `brew bundle --no-upgrade`). Casks Homebrew does not ship come from [petamorikei/homebrew-tap](https://github.com/petamorikei/homebrew-tap) |
| `fnox.toml` | `mise run apply`: Bitwarden item references for `[bootstrap.secrets]` |

Envs name facts about the machine:

| Env | Meaning |
|---|---|
| `desktop` | Has a GUI (always on macOS); Claude Code reports by voice |
| `main` | The main machine: voice reports use VOICEPEAK instead of VOICEVOX |
| `physical` | Not a virtual machine (Mac App Store apps) |
| `host` | Not a container (services, Docker, Samba) |
| `secrets` | Bitwarden is available (secret templates) |
| `work` | Work git config, WithSecure on macOS, gh account for the work directory (requires `secrets`) |
| `ubuntu` | Ubuntu (tools its apt ships too old) |

Packages keep their existing source: Homebrew on macOS, apt/pacman/AUR on
Linux, mise for tools Ubuntu's apt ships too old, cargo for Rust tools.

## gh accounts per directory

`gh auth switch` is global, so gh picks its account by directory instead:
`~/Workspace/mise.toml` sets `GH_TOKEN` to the personal account's token, and
on work machines the work directory's `mise.toml` (from `GH_WORK_DIR` and
`GH_WORK_USER` in Bitwarden) sets the work account's. Interactive shells get
it from mise's prompt hook; Claude Code's shell does not run that hook, so
`~/.claude/hooks/gh-account-guard.sh` stops its gh commands that would use
another account and has them rerun as `mise exec -- gh ...`.

## Never commit in plain text

This repository is public. Keep these out of it, or behind `secret()` and
Bitwarden:

- Secrets (tokens, passwords, keys, webhook URLs)
- Host names, IP addresses, network layout (tailnet names, SSH hosts)
- Anything that identifies an employer
