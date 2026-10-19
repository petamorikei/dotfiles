# CLAUDE.md / AGENTS.md

Guidance for coding agents working in this repository. `AGENTS.md` is a symlink
to this file.

## Repository Overview

This repository is a machine's global mise config, cloned to `~/.config/mise`
with `mise bootstrap --adopt petamorikei/dotfiles`. `mise bootstrap` applies
packages, tools, dotfiles, and macOS settings from it. kickstart (a separate,
private repository) runs it on new machines.

See README.md for the file layout and the env list.

## Rules

- **The repository is public.** Never commit secrets, host names, IP addresses,
  network layout, or anything that identifies an employer in plain text. Read
  secrets in templates with `secret(name=...)` (declared in `[bootstrap.secrets]`
  in config.toml, mapped to Bitwarden in fnox.toml).
- **Keep package sources.** Homebrew packages go in `Brewfile` (installed by
  real Homebrew); do not use mise's `brew:` / `brew-cask:` managers. Linux
  packages use `apt:`, `pacman:`, `aur:` in `[bootstrap.packages]`.
- Templates use Tera. Branch on `os()` for the platform and on
  `mise_env is defined and "<env>" in mise_env` for envs. Templates cannot see
  the distro; check `/etc/os-release` at runtime instead.
- Keep `. "$HOME/.atuin/bin/env"` and `atuin init zsh` in
  `templates/zshrc.tera` as they are: atuin's installer appends its own lines
  when they are missing.

## Common Commands

```bash
mise run apply                 # apply with secrets (needs BW_SESSION)
mise bootstrap --dry-run       # preview (renders no dotfile templates)
mise bootstrap status          # state of every part
mise dot status                # dotfile state
mise bootstrap secrets status  # which secret values are available
brew bundle check --file Brewfile
```

`mise bootstrap status` and `mise dot diff` render templates, which needs the
secret values on machines with the `secrets` env.
