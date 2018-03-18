# Aliases {{{

alias l="ls -AF"
alias ll="ls -lh"
alias la="ls -A"

alias ...="cd ../.."
alias ....="cd ../../.."

alias g="git"
alias gst="git status"
alias vim="nvim"
alias vi="nvim"
alias vip="nvim -c :FZF"
alias bx="bundle exec"

alias -g router_ip="\$(route -n get default -ifscope en0 | awk '/gateway/ { print \$2 }')"

alias docker-killall="docker ps | tail -n +2 | cut -f1 -d' ' | xargs docker kill"
alias docker-cleanup="docker ps -a | cut -f1 -d' ' | tail -n +2 | xargs docker rm"

alias fix-audio="sudo launchctl unload /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist"

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

# Completion {{{

# Complete ssh with hosts in ~/.ssh/config
zstyle -s ':completion:*:hosts' hosts _ssh_config
if [[ -r ~/.ssh/config ]]; then
  _ssh_config+=($(cat ~/.ssh/config | grep -v '\*' | sed -ne 's/Host[=\t ]//p'))
fi
zstyle ':completion:*:hosts' hosts $_ssh_config

# Complete Ruby versions with chruby
compctl -g '~/.rubies/*(:t)' chruby

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
zstyle ':completion:*' menu select list-colors "${(@s.:.)LS_COLORS}"


# Load the color constants (e.g. $fg)
autoload -Uz colors
colors

# Add more word separators
WORDCHARS=${WORDCHARS//[\/.-]}

# }}}

# Prompt {{{

setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats " %F{blue}%c%u %F{magenta}%b%f%{$reset_color%}"
precmd() {
  type notify-after-command > /dev/null && _post_cmd_notify
  vcs_info
}

function {
  local prompt_character="%(?,%{$fg[green]%},%{$fg[red]%})%(!,#,$)%{$reset_color%}"
  local cwd="%F{250}%c%f"

  PROMPT="$cwd $prompt_character "
  RPROMPT='${vcs_info_msg_0_}'
}

# }}}

# Custom functions {{{

code_dir="$HOME/src"
jp() {
  local candidates="$(find $code_dir -mindepth 3 -maxdepth 3 -type d |
    cut -f5- -d/ |
    grep -v "/\.")"
  if [ -z "$1" ]; then
    local dir="$(echo $candidates | fzf)"
    [[ $? == 0 && -n "$dir" ]] && cd "$code_dir/$dir" || true
  else
    if [ -d "$code_dir/$1" ]; then
      cd "$code_dir/$1"
    else
      local dir="$(echo $candidates | fzf --select-1 --query "$1")"
      [[ $? == 0 ]] && cd "$code_dir/$dir"
    fi
  fi
}
compctl -W "$code_dir" -/ jp

jgo() { cd ~/code/go/src/github.com/$1 }
compctl -W ~/code/go/src/github.com -/ jgo

vpn() {
  local vpn="${1:-💼 GoCardless}"
  local vpn_status=$(scutil --nc status $vpn | head -n1)

  if [[ "$vpn_status" == "Disconnected" ]]; then
    echo Connecting to VPN...
/usr/bin/env osascript <<-EOF
tell application "System Events"
  tell current location of network preferences
    set VPN to service "$vpn"
    if exists VPN then connect VPN
    repeat while (current configuration of VPN is not connected)
      delay 1
    end repeat
  end tell
end tell
EOF
    vpn_status=$(scutil --nc status $vpn | head -n1)
  fi

  echo "$vpn_status"
}

batt() {
  time_remaining=$(pmset -g batt | egrep "([0-9]+:[0-9]+)" -o)
  pct_remaining=$(pmset -g batt | egrep "([0-9]+\%)" -o)
  echo "$time_remaining remaining ($pct_remaining)"
}

_post_cmd_notify() {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  (notify-after-command "$CMD" "$LAST_EXIT_CODE" &) &> /dev/null
}

notify() {
  osascript \
    -e 'on run argv' \
    -e '  display notification item 1 of argv with title "Terminal"' \
    -e 'end' \
    -- $@
}

# }}}

# Languages {{{

# Ruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
[ -d ~/.rubies ] && chruby ruby-2.4.1

# Direnv, which helps switch between projects
eval "$(direnv hook zsh)"

# }}}

[ -f $HOME/.zshrc_local/zshrc ] && source $HOME/.zshrc_local/zshrc || true

