# Source Prezto (must come first)
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Note: If you symlinked Prezto's zshrc, it will automatically source Prezto.
# This section is for cases where you're using a custom .zshrc.

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Path
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"

# Apple Silicon support
if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# FZF configuration
if command -v fzf &> /dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# Aliases
alias vim='nvim'
alias vi='nvim'
alias ls='ls -lh'
alias la='ls -lah'
alias ll='ls -lh'

# Git aliases (in addition to .gitconfig)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gd='git diff'
alias pr='gh pr create --draft --body "" --title'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Key bindings for history navigation
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# Modern CLI tools (if installed)
if command -v eza &> /dev/null; then
  alias ls='eza -l'
  alias la='eza -la'
  alias tree='eza --tree'
fi

if command -v bat &> /dev/null; then
  alias cat='bat --style=plain --paging=never'
fi

if command -v rg &> /dev/null; then
  alias grep='rg'
fi

# Node version manager (if using nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load local configuration if it exists
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

alias python=python3
alias pip="python3 -m pip"
export PATH="/Users/pfista/Library/Python/3.14/bin:$PATH"
