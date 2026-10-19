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
mise run apply        # fnox exec -- mise bootstrap, from any directory
```

On machines with the `secrets` env, use `mise run apply`: plain
`mise bootstrap` stops because the secret templates have no values.

Files under `home/` are symlinked into `~`, so edits to them land here
directly. Templates under `templates/` and copies under `files/` are written on
apply: edit the source here, then apply.

## Layout

| Path | Loaded |
|---|---|
| `config.toml` | Always |
| `config.macos.toml`, `config.linux.toml` | By platform (`auto_env` in `miserc.toml`) |
| `config.<env>.toml` | When the env is in `miserc.local.toml` (written by kickstart, not committed) |
| `Brewfile` | macOS, by the `post-packages` hook (real Homebrew, `brew bundle --no-upgrade`) |
| `fnox.toml` | `mise run apply`: Bitwarden item references for `[bootstrap.secrets]` |

Envs name facts about the machine:

| Env | Meaning |
|---|---|
| `desktop` | Has a GUI (always on macOS) |
| `physical` | Not a virtual machine (Mac App Store apps) |
| `host` | Not a container (services, Docker, Samba) |
| `secrets` | Bitwarden is available (secret templates) |
| `work` | Work git config (requires `secrets`) |
| `ubuntu`, `manjaro` | Linux distribution |

Packages keep their existing source: Homebrew on macOS, apt/pacman/AUR on
Linux, mise for tools Ubuntu's apt ships too old, cargo for Rust tools.

## Never commit in plain text

This repository is public. Keep these out of it, or behind `secret()` and
Bitwarden:

- Secrets (tokens, passwords, keys, webhook URLs)
- Host names, IP addresses, network layout (tailnet names, SSH hosts)
- Anything that identifies an employer
