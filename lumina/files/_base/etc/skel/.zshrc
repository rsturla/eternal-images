# Path to oh-my-zsh installation
export ZSH=/usr/share/oh-my-zsh

# Set theme
ZSH_THEME="robbyrussell"

# Disable automatic updates (managed by system)
zstyle ':omz:update' mode disabled

# Plugins
plugins=(
  git
  direnv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Set EDITOR based on current environment
if [[ -n "$CURSOR_TRACE_ID" ]] || [[ "$TERM_PROGRAM" == "cursor" ]]; then
  export EDITOR='cursor --wait'
elif [[ -n "$VSCODE_INJECTION" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export EDITOR='code --wait'
elif command -v nvim &> /dev/null; then
  export EDITOR='nvim'
elif command -v vim &> /dev/null; then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi
