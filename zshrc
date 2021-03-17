# Aliases {{{

alias l="ls -AF"
alias ll="ls -lh"
alias la="ls -A"

alias ...="cd ../.."
alias ....="cd ../../.."

alias g="git"
alias gst="git status"
alias vi="vim"
alias vip="vim -c :FZF"
alias bx="bundle exec"

alias -g router_ip="\$(route -n get default -ifscope en0 | awk '/gateway/ { print \$2 }')"

alias docker-killall="docker ps | tail -n +2 | cut -f1 -d' ' | xargs docker kill"
alias docker-cleanup="docker ps -a | cut -f1 -d' ' | tail -n +2 | xargs docker rm"
alias docker-exec-latest="docker exec -ti \$(docker ps --latest --quiet) bash"

alias fix-audio="sudo launchctl unload /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist"
alias rubocop-changed="git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop"
alias rubocop-branch="git diff --name-only master | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop"
alias kill-gocode="ps -ef | grep \"\$HOME/bin/gocode\" | grep -v grep | awk '{ print \$2 }' | xargs kill -9"
alias flush-dns-cache="sudo killall -HUP mDNSResponder"

alias todo="vim ~/TODO.md"
alias tf="terraform"

alias vimrc="vim -p $HOME/.vimrc $HOME/.vim/vimrc-vanilla.vim $HOME/.vim/vimrc-extras.vim"

alias ecr-login='eval "$(aws ecr get-login --no-include-email)"'

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

# fzf fuzzy completion
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
  export FZF_COMPLETION_TRIGGER=''
  bindkey '^T' fzf-completion
  bindkey '^I' $fzf_default_completion
fi

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

function prompt_language_env {
  local language_env=""
  if [ -n "$VIRTUAL_ENV" ]; then
    language_env="🐍  "
  fi
  echo "$language_env"
}

function {
  local prompt_character="%(?,%{$fg[green]%},%{$fg[red]%})%(!,#,$)%{$reset_color%}"
  local cwd="%F{250}%c%f"
  if [ "$TERMINAL_THEME" = "light" ]; then
    cwd="%F{244}%c%f"
  fi

  PROMPT="\$(prompt_language_env)${cwd} ${prompt_character} "
  RPROMPT='${vcs_info_msg_0_}'
}

# }}}

# Custom functions {{{

code_dir="$HOME/src"
jp() {
  local candidates="$(find $code_dir -mindepth 3 -maxdepth 3 -type d |
    cut -f5- -d/ |
    grep -Ev "^ruby-" |
    grep -v "/\.")"
  if [ -z "$1" ]; then
    local dir="$(echo $candidates | fzf)"
    [[ $? == 0 && -n "$dir" ]] && cd "$code_dir/$dir" || true
  else
    if [ -d "$code_dir/$1" ]; then
      cd "$code_dir/$1"
    else
      local dir="$(echo $candidates | fzf --select-1 --query "$1")"
      [[ $? == 0 && -n "$dir" ]] && cd "$code_dir/$dir"
    fi
  fi
}
compctl -W "$code_dir" -/ jp
alias j=jp

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

gh-pr() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    repo=$(git remote get-url origin|sed "s/:/\\//; s/\\.git//; s/git@/https:\\/\\//")
    branch=$(git rev-parse --abbrev-ref HEAD)
    open "${repo}/compare/${branch}?expand=1"
  else
    echo "not in a git repo"
  fi
}

gh-open() {
  local file="$1"
  if git rev-parse --git-dir > /dev/null 2>&1; then
    repo=$(git remote get-url origin|sed "s/:/\\//; s/\\.git//; s/git@/https:\\/\\//")
    if [ -z "$file" ]; then
      open "${repo}"
    else
      local branch=$(git rev-parse --abbrev-ref HEAD)
      open "${repo}/blob/${branch}/${file}"
    fi
  else
    echo "not in a git repo"
  fi
}

gh-clone() {
  local repo="${1/https:\/\/github.com\//}"
  repo="${repo/git@github.com:/}"
  repo="${repo%.git}"
  if [[ ! "$repo" =~ "^[^/]+/[^/]+$" ]]; then
    echo "invalid repo - format must be ACCOUNT/NAME"
    return
  fi

  local dest="${code_dir}/github.com/$repo"
  if [ -e "$dest" ]; then
    echo "$dest: already exists"
    cd "$dest"
    return
  fi

  mkdir -p "$dest"
  git clone "git@github.com:$repo" "$dest"
  cd "$dest"
}

docker-debug() {
  if [ -z "$1" ]; then
    echo "usage: docker-debug CONTAINER-ID"
    return 1
  fi

  docker run --rm -ti \
    --pid="container:$1" \
    --net="container:$1" \
    --cap-add sys_admin \
    --cap-add sys_ptrace \
    hmarr/debug-tools
}

docker-debug-latest() {
  docker-debug "$(docker ps --latest --quiet)"
}

ssh_bin=$(which ssh)
ssh() {
  if ! ssh-add -l | grep "$HOME/.ssh/id_rsa" > /dev/null; then
    ssh-add "$HOME/.ssh/id_rsa"
  fi
  $ssh_bin "$@"
}

# }}}

# Languages {{{

# asdf to manage lanugage installations
if [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi

# Direnv, which helps switch between projects
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# }}}

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
[ -f $HOME/.zshrc_local/zshrc ] && source $HOME/.zshrc_local/zshrc || true
