#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

echo "======================================"
echo "  Dotfiles Setup Script"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

safe_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        local current_target
        current_target=$(readlink "$target")
        if [ "$current_target" = "$source" ]; then
            info "Symlink already correct: $target"
            return 0
        else
            warn "Symlink exists but points to $current_target, updating..."
            rm "$target"
        fi
    elif [ -e "$target" ]; then
        warn "File exists: $target. Creating backup..."
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    ln -s "$source" "$target"
    success "Created symlink: $target -> $source"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    warn "This script is optimized for macOS but will attempt to continue."
fi

echo ""
info "Step 1: Installing Homebrew (if needed)..."
if ! command_exists brew; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session (Apple Silicon)
    if [[ -d /opt/homebrew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    success "Homebrew already installed"
fi

echo ""
info "Step 2: Installing required packages..."

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    info "Found Brewfile. Installing packages with 'brew bundle'..."
    cd "$DOTFILES_DIR"
    brew bundle
    success "All Brewfile packages installed"

    # Set up default Node.js via fnm
    if command_exists fnm; then
        info "Setting up Node.js via fnm..."
        fnm install 20
        fnm default 20
        success "Node.js 20 set as default via fnm"
    fi
else
    info "Installing essential packages individually..."
    packages=(
        "zsh"
        "neovim"
        "fzf"
        "git"
        "node"
    )

    for package in "${packages[@]}"; do
        if ! command_exists "$package"; then
            info "Installing $package..."
            brew install "$package"
        else
            success "$package already installed"
        fi
    done
fi

echo ""
info "Step 3: Setting up Zsh..."

ZSH_PATH="$(which zsh)"

# Add zsh to /etc/shells if not already there
if ! grep -q "^${ZSH_PATH}$" /etc/shells; then
    info "Adding $ZSH_PATH to /etc/shells (requires sudo)..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    success "Added zsh to /etc/shells"
fi

# Change default shell if needed
if [ "$SHELL" != "$ZSH_PATH" ]; then
    info "Changing default shell to zsh..."
    chsh -s "$ZSH_PATH"
    success "Default shell changed to zsh (restart terminal to use)"
else
    success "Zsh is already the default shell"
fi

# Install Prezto (using forked repo)
ZPREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
if [ ! -d "$ZPREZTO_DIR" ]; then
    info "Installing Prezto from forked repo..."
    git clone --recursive https://github.com/pfista/prezto.git "$ZPREZTO_DIR"
    
    # Create symlinks for Prezto config files
    info "Creating Prezto configuration symlinks..."
    for rcfile in "$ZPREZTO_DIR"/runcoms/z*; do
        # Skip if it's the README
        if [[ $(basename "$rcfile") == "README.md" ]]; then
            continue
        fi
        
        target_file="${ZDOTDIR:-$HOME}/.$(basename "$rcfile")"
        
        # Check if our dotfiles repo has its own version of this file
        # Files live in zsh/ without the dot prefix (e.g., zsh/zshrc not .zshrc)
        basename_nodot="$(basename "$rcfile")"
        if [ -f "$DOTFILES_DIR/zsh/$basename_nodot" ]; then
            info "Skipping $target_file (custom version in dotfiles/zsh/)"
            continue
        fi
        
        if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
            warn "File exists: $target_file. Creating backup..."
            mv "$target_file" "${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        if [ ! -L "$target_file" ]; then
            ln -s "$rcfile" "$target_file"
            success "Linked $(basename "$rcfile")"
        fi
    done
    
    success "Prezto installed"
else
    success "Prezto already installed"
    
    # Update Prezto if it exists
    info "Checking for Prezto updates..."
    cd "$ZPREZTO_DIR"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git pull && git submodule sync --recursive && git submodule update --init --recursive
        success "Prezto updated"
    fi
    cd "$DOTFILES_DIR"
fi

echo ""
info "Step 4: Setting up FZF..."
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
    success "FZF configured"
fi

echo ""
info "Step 5: Creating symlinks for dotfiles..."

# Symlink zsh files
safe_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
safe_symlink "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
safe_symlink "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
safe_symlink "$DOTFILES_DIR/zsh/zlogin" "$HOME/.zlogin"
safe_symlink "$DOTFILES_DIR/zsh/zpreztorc" "$HOME/.zpreztorc"

# Symlink bash files
safe_symlink "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"
safe_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"

# Symlink git config
if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
    safe_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

if [ -f "$DOTFILES_DIR/.gitignore" ]; then
    safe_symlink "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
fi

# Create local gitconfig if it doesn't exist
if [ ! -f "$HOME/.gitconfig.local" ]; then
    info "Creating ~/.gitconfig.local from template..."
    if [ -f "$DOTFILES_DIR/.gitconfig.local.example" ]; then
        cp "$DOTFILES_DIR/.gitconfig.local.example" "$HOME/.gitconfig.local"
        warn "Please edit ~/.gitconfig.local and add your personal information!"
    else
        cat > "$HOME/.gitconfig.local" << 'EOF'
[user]
	name = Your Name
	email = your.email@example.com
EOF
        warn "Created basic ~/.gitconfig.local - please edit with your information!"
    fi
fi

# Set up SSH signing if SSH keys exist
echo ""
info "Checking SSH signing setup..."
SSH_KEY_FILE=""
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    SSH_KEY_FILE="$HOME/.ssh/id_ed25519.pub"
elif [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    SSH_KEY_FILE="$HOME/.ssh/id_rsa.pub"
elif [ -f "$HOME/.ssh/github.pub" ]; then
    SSH_KEY_FILE="$HOME/.ssh/github.pub"
fi

if [ -n "$SSH_KEY_FILE" ]; then
    success "Found SSH key: $SSH_KEY_FILE"
    
    # Create allowed_signers file for SSH signing
    if [ ! -f "$HOME/.ssh/allowed_signers" ]; then
        info "Creating ~/.ssh/allowed_signers for SSH commit signing..."
        SSH_KEY_CONTENT=$(cat "$SSH_KEY_FILE")
        # Extract email from git config or use a placeholder
        GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "your.email@example.com")
        echo "$GIT_EMAIL $SSH_KEY_CONTENT" > "$HOME/.ssh/allowed_signers"
        success "Created allowed_signers file"
    fi
    
    # Add key to SSH agent if not already added
    if command_exists ssh-add; then
        SSH_KEY_PRIVATE="${SSH_KEY_FILE%.pub}"
        if [ -f "$SSH_KEY_PRIVATE" ]; then
            info "Adding SSH key to agent..."
            ssh-add --apple-use-keychain "$SSH_KEY_PRIVATE" 2>/dev/null || ssh-add "$SSH_KEY_PRIVATE" 2>/dev/null || true
        fi
    fi
    
    echo ""
    warn "IMPORTANT: To use SSH commit signing on GitHub:"
    warn "  1. Copy your public key: cat $SSH_KEY_FILE | pbcopy"
    warn "  2. Go to: https://github.com/settings/keys"
    warn "  3. Click 'New SSH Key' and select 'Signing Key'"
    warn "  4. Paste and save"
    warn "  5. Update ~/.gitconfig.local with your signing key path:"
    warn "     signingkey = $SSH_KEY_FILE"
else
    warn "No SSH key found. Generate one with: ssh-keygen -t ed25519 -C \"your.email@example.com\""
fi

# Symlink eslint config
if [ -f "$DOTFILES_DIR/.eslintrc" ]; then
    safe_symlink "$DOTFILES_DIR/.eslintrc" "$HOME/.eslintrc"
fi

# Symlink editorconfig
if [ -f "$DOTFILES_DIR/.editorconfig" ]; then
    safe_symlink "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
fi

# Create git template directory if referenced in gitconfig
if [ -d "$DOTFILES_DIR/.git_template" ]; then
    safe_symlink "$DOTFILES_DIR/.git_template" "$HOME/.git_template"
fi

echo ""
info "Step 6: Setting up Neovim..."

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Symlink nvim config
safe_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

# Symlink Ghostty config
mkdir -p "$CONFIG_DIR/ghostty"
safe_symlink "$DOTFILES_DIR/ghostty/config" "$CONFIG_DIR/ghostty/config"

# Create backup directory
mkdir -p "$DOTFILES_DIR/nvim/backup"
success "Created nvim backup directory"

# Install lazy.nvim if not already installed
LAZY_PATH="$CONFIG_DIR/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    info "Installing lazy.nvim plugin manager..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
    success "lazy.nvim installed"
else
    success "lazy.nvim already installed"
fi

echo ""
info "Step 7: Installing Hack Nerd Fonts..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

mkdir -p "$FONT_DIR"

if [ -d "$DOTFILES_DIR/fonts/Hack" ]; then
    info "Copying Hack Nerd Fonts..."
    cp "$DOTFILES_DIR/fonts/Hack"/*.ttf "$FONT_DIR/"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        fc-cache -f "$FONT_DIR"
    fi
    
    success "Hack Nerd Fonts installed"
fi

echo ""
info "Step 8: Terminal Configuration..."
info "Ghostty config has been symlinked to ~/.config/ghostty/config"
info "You can launch Ghostty as your primary terminal emulator."
echo ""
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -f "$DOTFILES_DIR/iterm2-profile.json" ]; then
        info "iTerm2 profile found at: $DOTFILES_DIR/iterm2-profile.json"
        info "To load iTerm2 profile:"
        info "  1. Open iTerm2"
        info "  2. Go to Preferences -> Profiles"
        info "  3. Click 'Other Actions' -> Import JSON Profiles"
        info "  4. Select: $DOTFILES_DIR/iterm2-profile.json"
    fi
    
    if [ -f "$DOTFILES_DIR/com.googlecode.iterm2.plist" ]; then
        info "iTerm2 plist found. You can import it using:"
        info "  cp $DOTFILES_DIR/com.googlecode.iterm2.plist ~/Library/Preferences/"
    fi
    
    if [ -f "$DOTFILES_DIR/color.itermcolors" ] || [ -f "$DOTFILES_DIR/snazzy.itermcolors" ]; then
        info "iTerm2 color schemes found in $DOTFILES_DIR"
        info "To import: iTerm2 -> Preferences -> Profiles -> Colors -> Color Presets -> Import"
    fi
fi

echo ""
info "Step 9: Installing Claude Code CLI..."
if ! command_exists claude; then
    info "Installing Claude Code via official installer..."
    curl -fsSL https://claude.ai/install.sh | bash
    success "Claude Code CLI installed"
else
    success "Claude Code CLI already installed"
fi

echo ""
info "Step 10: Final touches..."

# Suppress "Last login" message in new terminal sessions
touch "$HOME/.hushlogin"
success "Created ~/.hushlogin (suppresses 'Last login' message)"

# Create ~/.zshrc.local template if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    cat > "$HOME/.zshrc.local" << 'EOF'
# Machine-specific shell config
# This file is sourced at the end of ~/.zshrc
# It is NOT version-controlled — edit freely for this machine

# Example: Docker via Colima
# export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock

# Example: Machine-specific aliases
# alias ol='ollama run deepseek-r1:8b'
EOF
    success "Created ~/.zshrc.local template"
fi

echo ""
echo "======================================"
success "Dotfiles setup complete!"
echo "======================================"
echo ""
echo "--------------------------------------"
warn "ACTION REQUIRED: Update these files for this machine"
echo "--------------------------------------"
echo ""
warn "1. ~/.gitconfig.local"
echo "   Set your name, email, and 1Password SSH signing key."
echo "   Template has been copied from .gitconfig.local.example."
echo "   Edit with: nvim ~/.gitconfig.local"
echo ""
warn "2. ~/.zshrc.local"
echo "   Add machine-specific shell config (Docker host, local aliases, etc.)."
echo "   A starter template has been created."
echo "   Edit with: nvim ~/.zshrc.local"
echo ""
warn "3. 1Password"
echo "   Open 1Password > Settings > Developer > Enable SSH Agent."
echo "   This is required for git commit signing and SSH auth."
echo ""
info "Everything else is ready:"
echo "  - Restart your terminal or run: source ~/.zshrc"
echo "  - Open nvim and let lazy.nvim install plugins"
echo "  - Ghostty is configured at ~/.config/ghostty/config"
echo ""

