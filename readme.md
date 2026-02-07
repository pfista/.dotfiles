# Dotfiles

Personal dotfiles for macOS development. Zsh + Prezto, Neovim, Ghostty.

## Setup

```bash
git clone git@github.com:pfista/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./setup.sh
```

The script handles everything: Homebrew, packages, Prezto, symlinks, Neovim, fonts, Ghostty, Claude Code CLI. At the end it prints the 3 things you need to configure manually.

## Post-Setup (manual)

These files are created by the setup script but need your info:

1. **`~/.gitconfig.local`** — your name, email, and 1Password SSH signing key
2. **`~/.zshrc.local`** — machine-specific shell config (Docker host, local aliases, etc.)
3. **1Password** — open the app, go to Settings > Developer > enable SSH Agent

## What's Included

### Shell (Zsh + Prezto)

- [Prezto](https://github.com/pfista/prezto) fork with vi-mode, git, syntax-highlighting, autosuggestions
- [fzf](https://github.com/junegunn/fzf) for fuzzy file/history search + [fzf-tab](https://github.com/Aloxaf/fzf-tab) for fuzzy completions
- [zoxide](https://github.com/ajeetdsouza/zoxide) — smart `cd` (`z proj` jumps to frecent dirs)
- [atuin](https://github.com/atuinsh/atuin) — enhanced shell history with ctrl-r TUI
- [eza](https://github.com/eza-community/eza), [bat](https://github.com/sharkdp/bat), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [delta](https://github.com/dandavison/delta) — modern CLI replacements

### Terminal

- **[Ghostty](https://ghostty.org/)** — GPU-accelerated, native macOS terminal. Config at `ghostty/config`.
  Auto-switches theme with system dark/light mode (Mathias dark, Monokai Pro Light).
- iTerm2 profiles and color schemes also included (legacy)

### Editor

- Neovim with [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager
- Config in `nvim/lua/`

### Git

- Delta for side-by-side diffs
- 1Password SSH commit signing (template in `.gitconfig.local.example`)
- Custom aliases: `git s <branch>` (smart switch/create), `git lg`, `git b` (branches by date)

### Dev Tools (via Brewfile)

fnm (Node), pyenv (Python), rbenv (Ruby/CocoaPods), pnpm, deno, gh

## Structure

```
.dotfiles/
├── zsh/                      # Zsh runcoms (zshrc, zpreztorc, zshenv, etc.)
├── nvim/                     # Neovim config
├── ghostty/                  # Ghostty terminal config
├── bash/                     # Bash config (fallback)
├── fonts/                    # Hack Nerd Font
├── setup.sh                  # Automated setup script
├── Brewfile                  # Homebrew dependencies
├── .gitconfig                # Git config (shared)
├── .gitconfig.local.example  # Template for machine-specific git config
├── .zshrc.local.example      # Template for machine-specific shell config
├── .gitignore                # Global gitignore
├── .editorconfig             # EditorConfig
└── .eslintrc                 # ESLint config
```

## Machine-Specific Files

These files live in `$HOME` only (not symlinked, not version-controlled):

| File | Purpose | Created by |
|------|---------|------------|
| `~/.gitconfig.local` | Name, email, signing key | `setup.sh` (from template) |
| `~/.zshrc.local` | Docker host, local aliases | `setup.sh` (starter template) |
| `~/.hushlogin` | Suppresses "Last login" message | `setup.sh` |

## Customization

- **Shell aliases**: `zsh/zshrc` (shared) or `~/.zshrc.local` (machine-specific)
- **Git config**: `.gitconfig` (shared) or `~/.gitconfig.local` (machine-specific)
- **Ghostty**: `ghostty/config`
- **Neovim plugins**: `nvim/lua/plugins/`
- **Brew packages**: `Brewfile`
