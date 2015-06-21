# Aliases {{{

alias l="ls -AF"
alias ll="ls -lh"
alias la="ls -A"

alias ...="cd ../.."
alias ....="cd ../../.."

alias g="git"
alias gst="git status"
alias vi="vim"
alias bx="bundle exec"

# }}}

# History {{{

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

# }}}

# Key bindings {{{

# Emacs-style key bindings
bindkey -e

# Kill backwards rather than the whole line
bindkey '^U' backward-kill-line

# Shift-tab to cycle back through menus
bindkey '^[[Z' reverse-menu-complete

# Fix broken alt key on OS X
bindkey '∫' backward-word
bindkey 'ƒ' forward-word

# Fix fn-backspace on OS X
bindkey '^[[3~' delete-char

# History expansion on space
bindkey ' ' magic-space

# }}}

# General config {{{

# Allow comments in interactive shells
setopt interactive_comments

# Change directory without typing cd
setopt autocd

# Auto-escape URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

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

# }}}

# Plugins {{{

if [ -f ~/.zgen/zgen.zsh ]; then
  ZGEN_DIR=~/.zgen/plugins
  source ~/.zgen/zgen.zsh

  if ! zgen saved; then
    echo "creating a zgen save"

    zgen oh-my-zsh plugins/chruby
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load supercrabtree/k

    zgen save
  fi
else
  echo "warning: zgen is not installed, plugins won't be enabled"
fi

# }}}

# Prompt {{{

setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats " %F{blue}%c%u %F{yellow}%b%{$reset_color%}"
precmd() {
  vcs_info
}

function {
  local prompt_character="%(?,%{$fg[green]%},%{$fg[red]%})%(!,#,$)%{$reset_color%}"
  local cwd="%{$fg[grey]%}%c%{$reset_color%}"

  PROMPT="$cwd $prompt_character "
  RPROMPT='${vcs_info_msg_0_}'
}

# }}}

# Custom functions {{{

jp() { cd ~/projects/$1 }
compctl -W ~/projects -/ jp

# }}}

