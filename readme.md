# Dotfiles

My personal dotfiles for macOS development environment with Neovim, Zsh, and iTerm2.

## Features

- **Shell**: Zsh with Prezto framework
- **Editor**: Neovim with lazy.nvim plugin manager
- **Terminal**: iTerm2 with custom profiles and color schemes
- **Tools**: FZF, Git aliases, and more
- **Fonts**: Hack Nerd Font included

## Quick Setup

```bash
# Clone the repo to your home directory
cd ~
git clone git@github.com:pfista/.dotfiles.git

# Run the setup script
cd ~/.dotfiles
./setup.sh
```

The setup script will automatically:
- Install Homebrew (if not present)
- Install required packages via Brewfile (zsh, neovim, fzf, git, node, ripgrep, etc.)
- Set up Zsh and Prezto (from forked repo: `pfista/prezto`)
- Create symlinks for all configuration files
- Set up Neovim with lazy.nvim
- Install Hack Nerd Fonts
- Create `.gitconfig.local` from template
- Provide instructions for iTerm2 configuration

## Manual Setup (if preferred)

### Core Dotfiles

```bash
ln -s ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/bash/bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.gitignore ~/.gitignore
ln -s ~/.dotfiles/.eslintrc ~/.eslintrc
```

### Neovim

```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
mkdir -p ~/.dotfiles/nvim/backup
```

### iTerm2 (macOS)

1. Open iTerm2 preferences
2. Go to Profiles → Other Actions → Import JSON Profiles
3. Select `~/.dotfiles/iterm2-profile.json`
4. Import color schemes from `color.itermcolors` or `snazzy.itermcolors`

## Post-Installation

1. Restart your terminal or run `source ~/.zshrc`
2. Open `nvim` and lazy.nvim will automatically install plugins
3. Review and update `~/.gitconfig` with your personal information
4. Configure iTerm2 with the provided profiles

## Structure

```
.dotfiles/
├── bash/                    # Bash configuration files
├── nvim/                    # Neovim configuration
│   ├── lua/                 # Lua configuration
│   └── colors/              # Color schemes
├── fonts/                   # Hack Nerd Font
├── setup.sh                 # Automated setup script
├── .zshrc                   # Zsh configuration
├── .gitconfig               # Git configuration (shared)
├── .gitconfig.local.example # Template for personal git config
├── .gitignore               # Global gitignore
├── .eslintrc                # ESLint configuration
├── .editorconfig            # EditorConfig for consistent coding styles
├── Brewfile                 # Homebrew dependencies
└── *.itermcolors            # iTerm2 color schemes
```

## Customization

- **Shell aliases**: Edit `bash/bashrc`
- **Git aliases**: Edit `.gitconfig`
- **Neovim config**: Edit `nvim/lua/config/`
- **Neovim plugins**: Edit `nvim/lua/plugins/`

