# dotfiles

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Usage

### With Bitwarden (default)

Some files require secrets from Bitwarden. Unlock Bitwarden before applying:

```bash
export BW_SESSION=$(bw unlock --raw)
chezmoi init petamorikei
chezmoi apply
```

### Without Bitwarden

Skip secret-dependent files by setting `SKIP_SECRETS=1`:

```bash
SKIP_SECRETS=1 chezmoi init petamorikei
SKIP_SECRETS=1 chezmoi apply
```

Git and SSH configurations will be excluded.
