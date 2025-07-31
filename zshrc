# Aliases {{{

alias l="ls -AF"
alias ll="ls -lh"
alias la="ls -A"

alias ...="cd ../.."
alias ....="cd ../../.."

alias g="git"
alias gst="git status"
alias gpb="git push -u origin \$(git branch --show-current)"
alias vi="vim"
vip() {
  local preview_cmd='head -n 200 {1}'
  if command -v bat &> /dev/null; then
    preview_cmd='bat {1} --color=always --line-range :200'
  fi
  local file_paths=($(rg --files | fzf -m --preview "$preview_cmd"))
  if [ ${#file_paths[@]} -gt 0 ]; then
    vim -p "${file_paths[@]}"
  fi
}

alias c="claude"

alias -g router_ip="\$(route -n get default -ifscope en0 | awk '/gateway/ { print \$2 }')"

alias docker-killall="docker ps | tail -n +2 | cut -f1 -d' ' | xargs docker kill"
alias docker-cleanup="docker ps -a | cut -f1 -d' ' | tail -n +2 | xargs docker rm"
alias docker-exec-latest="docker exec -ti \$(docker ps --latest --quiet) bash"

alias flush-dns-cache="sudo killall -HUP mDNSResponder"

alias todo="vim ~/TODO.md"

alias tf="terraform"

alias vimrc="vim -p $HOME/.vimrc $HOME/.vim/vimrc-vanilla.vim $HOME/.vim/vimrc-extras.vim"

alias fast='networkQuality -v'

# }}}

# History {{{

# Save history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Better history
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
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

# Languages {{{

# asdf to manage lanugage installations
if [ -f ~/.asdf/asdf.sh ]; then
  source ~/.asdf/asdf.sh

  # append completions to fpath, must be before `compinit` is run
  fpath=(${ASDF_DIR}/completions $fpath)
fi

# Direnv, which helps switch between projects
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# }}}

# Completion {{{

# Complete ssh with hosts in ~/.ssh/config
zstyle -s ':completion:*:hosts' hosts _ssh_config
if [[ -r ~/.ssh/config ]]; then
  _ssh_config+=($(cat ~/.ssh/config | grep -v '\*' | sed -ne 's/Host[=\t ]//p'))
fi
zstyle ':completion:*:hosts' hosts $_ssh_config

# fzf fuzzy completion
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
  export FZF_CTRL_R_OPTS="
    --wrap
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"
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

# Enable Ctrl-x-e to edit the command line in an editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

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
  if [ -z "$NO_GIT_STATUS_IN_PROMPT" ]; then
    zstyle ':vcs_info:*' check-for-changes true
  else
    zstyle ':vcs_info:*' check-for-changes false
  fi
  vcs_info
}

prompt_host() {
  echo "${PROMPT_HOSTNAME:-$(hostname)}"
}

# Define an empty prompt_extra if it's not defined
(( ${+functions[prompt_extra]} )) || prompt_extra() {}

function set_prompt {
  local prompt_character="%(?,%{$fg[green]%},%{$fg[red]%})%(!,#,$)%{$reset_color%}"
  local cwd="%F{250}%c%f"
  if [ "$TERMINAL_THEME" = "light" ]; then
    cwd="%F{244}%c%f"
  fi

  PROMPT="%F{134}\$(prompt_host) %F{71}\$(prompt_extra)%f%F{166}%(4~|%-1~/…/%2~|%3~)%f $prompt_character "
  RPROMPT='${vcs_info_msg_0_}'
}
set_prompt

# }}}

# Custom functions {{{

code_dir="${CODE_DIR:-$HOME/src}"
jp() {
  local candidates="$(find "$code_dir" -mindepth 3 -maxdepth 3 -type d |
    cut -f5- -d/ |
    grep -Ev "^ruby-" |
    grep -v "/\.")"
  if [ -z "$1" ]; then
    local dir="$(echo "$candidates" | fzf)"
    [[ $? == 0 && -n "$dir" ]] && cd "$code_dir/$dir" || true
  else
    if [ -d "$code_dir/$1" ]; then
      cd "$code_dir/$1"
    else
      local dir="$(echo "$candidates" | fzf --select-1 --query "$1")"
      [[ $? == 0 && -n "$dir" ]] && cd "$code_dir/$dir"
    fi
  fi
}
compctl -W "$code_dir" -/ jp

batt() {
  time_remaining=$(pmset -g batt | grep -Eo "([0-9]+:[0-9]+)")
  pct_remaining=$(pmset -g batt | grep -Eo "([0-9]+\%)")
  echo "$time_remaining remaining ($pct_remaining)"
}

gh-pr() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local repo=$(git remote get-url origin|sed "s/:/\\//; s/\\.git//; s/git@/https:\\/\\//")
    local branch=$(git rev-parse --abbrev-ref HEAD)
    open "${repo}/compare/${branch}?expand=1"
  else
    echo "not in a git repo"
  fi
}

gh-open() {
  local file="$1"
  if git rev-parse --git-dir > /dev/null 2>&1; then
    repo=$(git remote get-url origin|sed "s/:/\\//; s/\\.git//; s/git@/https:\\/\\//; s/https\\/\\//https:\\//")
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
  if [[ ! "$repo" =~ ^[^/]+/[^/]+$ ]]; then
    echo "invalid repo - format must be ACCOUNT/NAME"
    return
  fi

  local dest="${code_dir}/github.com/$repo"
  if [ -e "$dest" ]; then
    echo "$dest: already exists"
    cd "$dest"
    return
  fi

  mkdir -p "$(dirname $dest)"
  if git clone "https://github.com/$repo" "$dest"; then
    cd "$dest"
  fi
}

gs() {
  local branch="$(git branch | fzf | sed 's/^\* //' | awk '{print $1}')"
  if [ -n "$branch" ]; then
    git switch "$branch"
  fi
}

prs() {
  local author="${1:-@me}"
  GH_FORCE_TTY=true gh pr list --author "$author" |
    tail +5 |
    fzf \
      --ansi \
      --header 'ctrl-o: open in browser | alt-p: preview | alt-u: copy url | alt-y: copy branch' \
      --bind 'ctrl-o:become(gh pr view --web {1})' \
      --bind 'alt-u:execute-silent(gh pr view --json url $(echo {1} | sed "s/#//") | jq -r .url | pbcopy)' \
      --bind 'alt-y:execute-silent(gh pr view --json headRefName -q .headRefName {1} | pbcopy)' \
      --bind 'alt-p:toggle-preview' \
      --preview-window=hidden \
      --preview='GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr view {1}'
}

docker-debug() {
  if [ -z "$1" ]; then
    echo "usage: docker-debug CONTAINER-ID"
    return 1
  fi

  echo "Starting debug sidecar for container $1"

  [ ! -d "/tmp/debug-$1" ] && mkdir "/tmp/debug-$1"
  echo "Mounting /scratch to /tmp/debug-$1"

  docker run --rm -ti \
    --name="debug-${1:0:6}" \
    --workdir="/scratch" \
    --volume="/tmp/debug-$1:/scratch" \
    --pid="container:$1" \
    --network="container:$1" \
    --cap-add sys_admin \
    --cap-add sys_ptrace \
    hmarr/debug-tools
}

docker-debug-latest() {
  docker-debug "$(docker ps --latest --quiet)"
}

ssh_bin=$(which ssh)
ssh() {
  if [ -e "$HOME/.ssh/id_ed25519" ]; then
    if ! ssh-add -l | grep "hmarr@" > /dev/null; then
      ssh-add "$HOME/.ssh/id_ed25519"
    fi
  fi
  $ssh_bin "$@"
}

npm-upgrade-deps() {
  if [ ! -f package.json ]; then
    echo "no package.json found"
    return 1
  fi

  if jq -e .dependencies package.json > /dev/null; then
    echo "Upgrading dependencies:"
    jq '.dependencies | keys | .[] | (. + "@latest")' package.json

    local proceed

    read -q "proceed?Go ahead? [Y/n]"
    echo
    if [[ "$proceed" == "y" ]] ; then
      jq '.dependencies | keys | .[] | (. + "@latest")' package.json | xargs npm install
    fi
  else
    echo "No dependencies found"
  fi

  if jq -e .devDependencies package.json > /dev/null; then
    echo "Upgrading devDependencies:"
    jq '.devDependencies | keys | .[] | (. + "@latest")' package.json

    read -q "proceed?Go ahead? [Y/n]"
    echo
    if [[ "$proceed" == "y" ]] ; then
      jq '.devDependencies | keys | .[] | (. + "@latest")' package.json | xargs npm install
    fi
  else
    echo "No devDependencies found"
  fi
}

backup() {
  if [ -z "$1" ]; then
    echo "usage: backup FILE"
    return
  fi

  local backup_dir="$HOME/backups"
  if [ ! -d "$backup_dir" ]; then
    echo "backup directory $backup_dir does not exist"
    return
  fi

  if [ ! -e "$1" ]; then
    echo "no file or directory found at path '$1'"
    return
  fi

  local src_path=$(realpath "$1")
  local timestamp=$(date "+%Y-%m-%d--%H-%M-%S")
  local dst_path="$backup_dir/$timestamp$src_path"
  local dst_dir=$(dirname "$dst_path")

  echo "Creating backup"
  echo "  source      = $src_path"
  echo "  destination = $dst_path"
  [ ! -d "$dst_dir" ] && mkdir -p "$dst_dir"
  cp -r "$src_path" "$dst_path"
}

csvq() {
  csvpath="$1"
  if [ -z "$csvpath" ]; then
    echo "usage: csvq CSV-FILE QUERY"
    return 1
  fi
  if [ ! -e "$csvpath" ]; then
    echo "no csv file found at path '$csvpath'"
    return 1
  fi

  query="$2"
  if [ -z "$query" ]; then
    echo "usage: csvq CSV-FILE QUERY"
    return 1
  fi

  sqlite3 -csv -cmd ".import ""$csvpath"" data" ':memory:' "$query"
}

csv2sqlite() {
  csvpath="$1"
  if [ -z "$csvpath" ]; then
    echo "usage: csv2sqlite CSV-FILE"
    return 1
  fi
  if [ ! -e "$csvpath" ]; then
    echo "no csv file found at path '$csvpath'"
    return 1
  fi

  basename="${csvpath%.csv}"
  dbpath="$basename.sqlite"
  if [ -e "$dbpath" ]; then
    echo "$dbpath already exists, aborting"
    return 1
  fi

  tablename="${basename//[^[:alnum:]]/}"
  sqlite3 -csv -cmd ".import ""$csvpath"" $tablename" "$dbpath" ""
  echo "created $dbpath"
}

# }}}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc_local/zshrc ] && source ~/.zshrc_local/zshrc || true
