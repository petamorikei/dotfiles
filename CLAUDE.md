# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a chezmoi dotfiles repository. Chezmoi manages dotfiles by storing them in this source directory and applying them to the home directory (`~`).

## Common Commands

```bash
# Apply changes to home directory
chezmoi apply

# Apply changes with verbose output
chezmoi apply -v

# Preview changes before applying (dry run)
chezmoi diff

# Add a file from home directory to chezmoi
chezmoi add ~/.filename

# Edit a managed file (opens in $EDITOR)
chezmoi edit ~/.filename

# Update from remote and apply
chezmoi update

# Re-add a file after manual edits in source
chezmoi re-add ~/.filename

# Check managed files status
chezmoi status

# Initialize on a new machine
chezmoi init <github-username>
```

## File Naming Conventions

Chezmoi uses special prefixes in filenames:

- `dot_` → becomes `.` (e.g., `dot_bashrc` → `.bashrc`)
- `private_` → file permissions set to 0600
- `executable_` → file permissions include execute bit
- `empty_` → ensures file exists, even if empty
- `create_` → only creates if file doesn't exist
- `modify_` → script that modifies existing file
- `remove_` → removes file from target
- `run_` → script to run (not a managed file)
- `run_once_` → script runs once per machine
- `run_onchange_` → script runs when its content changes

Prefixes can be combined: `private_dot_ssh/private_config`

## Template Files

Files ending in `.tmpl` are Go templates. Use for machine-specific configuration:

```
{{ .chezmoi.hostname }}
{{ .chezmoi.os }}
{{ .chezmoi.arch }}
{{ if eq .chezmoi.os "darwin" }}macOS specific{{ end }}
```

## Directory Structure

- `.chezmoiignore` - patterns to ignore when applying
- `.chezmoiexternal.toml` - external files/archives to download
- `.chezmoiroot` - specifies a subdirectory as the root
- `.chezmoidata.yaml` - template data
