# Chezmoi Dotfiles — CLAUDE.md

This repo manages a cross-platform (macOS + Linux) development environment using [chezmoi](https://www.chezmoi.io/).

## Repo Layout

```
home/                              # chezmoi root (set by .chezmoiroot)
├── .chezmoi.toml.tmpl             # Data: name, email, package list
├── .chezmoiscripts/
│   └── run_onchange_before_install-packages.sh.tmpl   # Package installer + macOS defaults
├── dot_claude/                    # → ~/.claude/
│   ├── CLAUDE.md                  # Global Claude Code instructions
│   ├── private_settings.json      # Status line config
│   └── statusline/                # Custom powerline-style status scripts
├── private_dot_config/            # → ~/.config/
│   ├── ghostty/                   # Terminal config
│   ├── nvim/                      # Neovim (lazy.nvim, Lua)
│   └── zsh/                       # Modular zsh config (cfg/00–04)
└── dot_zshenv                     # Sets ZDOTDIR, EDITOR
```

## Chezmoi Conventions

**File name prefixes** (chezmoi strips these on apply):
- `dot_` → `.`  (e.g., `dot_zshrc` → `.zshrc`)
- `private_` → file is marked sensitive/encrypted
- `.tmpl` suffix → processed as Go text/template before applying

**Template data** comes from `.chezmoi.toml.tmpl`. Key variables:
- `.chezmoi.os` — `"darwin"` or `"linux"`
- `.chezmoi.username`, `.name`, `.email`, `.git_username`
- `.packages` — list of packages; each entry is either a plain string or a map with OS-specific keys (`brew`, `cask`, `aur`)

**Script triggers:**
- `run_onchange_before_` — runs before other scripts, only when its content hash changes

## Package System

Packages are declared in `.chezmoi.toml.tmpl` under `[data]`. The install script (`run_onchange_before_install-packages.sh.tmpl`) iterates them and calls the right package manager:

| Platform | Official | Extra |
|----------|----------|-------|
| macOS    | `brew install` | `brew install --cask` |
| Linux    | `pacman -S` | `yay -S` (AUR) |

To add a package: add it to the `packages` list in `.chezmoi.toml.tmpl`. Use a map when the package name differs by manager:
```toml
{ brew = "ripgrep", aur = "ripgrep" }
{ cask = "ghostty" }   # macOS cask only
```

## Key Tools Configured

- **Zsh** — antidote plugin manager; modular cfg/ files loaded in order (`00_antidote` → `04_programs`)
- **Neovim** — lazy.nvim with plugins in `lua/plugins/` organized by category (`ui/`, `coding/`, `git/`, `lsp/`)
- **Ghostty** — terminal with Selenized light/dark theme and split keybindings
- **Claude Code** — custom powerline statusline showing model, git info, usage %, context %, task queue

## Workflow

```sh
chezmoi apply          # Apply changes to home dir
chezmoi diff           # Preview what would change
chezmoi cd             # Jump to this repo
chezmoi re-add <file>  # Pull a file's current state back into the repo
```

After editing template files, run `chezmoi apply` to verify output is correct before committing.

## Things to Always Do

- Test template changes with `chezmoi apply --dry-run` before committing
- Keep OS-specific logic inside `.tmpl` files using `{{ if eq .chezmoi.os "darwin" }}` blocks
- Use `private_` prefix for any file containing tokens, keys, or personal identifiers
- Keep the package list in `.chezmoi.toml.tmpl` as the single source of truth — do not hardcode package names in the install script

## Things to Never Do

- Do not edit files under `~/.config/` or `~/` directly when the source of truth is this repo — always edit the chezmoi source
- Do not add secrets or credentials in plain text (use `private_` prefix + chezmoi encryption, or env vars)
- Do not break the numbered ordering of `zsh/cfg/` files — sourcing order matters
- Do not commit `lazy-lock.json` (it is in `.chezmoiignore`)
