  # Claude Code Configuration

  ## About Me
  - Full-stack developer working across macOS and Linux (Arch)
  - Primary editor: Neovim, vs-code, IntelliJ; terminal: Ghostty
  - Runtime versions managed via asdf

  ## Code Style Preferences
  - 2-space indentation (spaces, not tabs)

  ## Tools & Workflow
  - Package manager: brew (macOS) / pacman + yay (Linux)
  - Use `gh` for GitHub operations (not raw `git` for PRs/issues)
  - Use `fd` instead of `find`, `rg` instead of `grep` where possible
  - Node.js managed via asdf; use `corepack`-provided yarn/pnpm rather than npm where possible

  ## Dotfiles (chezmoi)
  Many config files under `~/.config/`, `~/.claude/`, and `~/` are managed by chezmoi.
  The source of truth is `~/.local/share/chezmoi/`. When editing dotfiles:
  - Always edit the chezmoi source, never the applied file directly
  - Use chezmoi conventions: `dot_` prefix, `private_` for sensitive files, `.tmpl` for templates
  - Keep OS-specific logic in `.tmpl` files using `{{ if eq .chezmoi.os "darwin" }}` blocks
  - After editing, apply with `chezmoi apply`

  ## Things to Always Do
  - Prefer editing existing files over creating new ones

  ## Things to Never Do
  - Do not add `npm install -g` — use asdf/corepack instead
  - Do not add comments explaining what code does unless the logic is genuinely non-obvious