# Aliases
alias l="ls -AF"
alias ll="ls -lh"
alias la="ls -A"
alias ...="cd ../.."
alias ....="cd ../../.."

# Save history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Better history
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_VERIFY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Emacs-style key bindings
bindkey -e

# Allow comments in interactive shells
setopt interactive_comments

# Change directory without typing cd
setopt autocd

# Auto-escape URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Shift-tab to cycle back through menus
bindkey '^[[Z' reverse-menu-complete

# Better completion
autoload -Uz compinit
compinit

# Select menu items when tabbing through
zstyle ':completion:*' menu select

# Load the color constants (e.g. $fg)
autoload -Uz colors
colors

# Add more word separators
WORDCHARS=${WORDCHARS//[\/.-]}

if [ -f ~/.antigen.zsh ]; then
  source ~/.antigen.zsh
  antigen bundle zsh-users/zsh-syntax-highlighting
else
  echo "warning: antigen is not installed, plugins won't be enabled"
fi

# Prompt
setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats ' %F{blue}%c%u %F{green}%b'
precmd() {
  vcs_info
}

function {
  local prompt_character="%(?,%{$fg[green]%},%{$fg[red]%})%(!,#,$)%{$reset_color%}"
  local cwd="%{$fg[grey]%}%c%{$reset_color%}"

  PROMPT="$cwd $prompt_character "
  RPROMPT='${vcs_info_msg_0_}'
}

