#!/bin/bash

if [ -z "$OVERWRITE_DOTFILES" ]; then
  if [ "$CODESPACES" = "true" ]; then
    OVERWRITE_DOTFILES=true
  fi
fi

red() {
  echo " $(tput setaf 1)$*$(tput setaf 9)"
}

yellow() {
  echo " $(tput setaf 3)$*$(tput setaf 9)"
}

green() {
  echo " $(tput setaf 2)$*$(tput setaf 9)"
}

move_to_backup_dir() {
  local file_path="$1"
  local current_path="$HOME/$file_path"
  local backup_path="$HOME/.dotfiles-backup/$file_path"
  local backup_dir="$(dirname "$backup_path")"

  if [ ! -d "$backup_dir" ]; then
    if ! mkdir -p "$backup_dir"; then
      return 1
    fi
  fi

  mv "$current_path" "$backup_path"
  return $?
}

link_dotfile() {
  local source="$1"
  local dest="$2"
  local full_dest="$HOME/$dest"

  if [ -L "$full_dest" ] && [ "$full_dest" -ef "$source" ]; then
    yellow "✔ $dest is already linked"
    return
  fi

  if [ -e "$full_dest" ]; then
    if [ "$OVERWRITE_DOTFILES" = "true" ]; then
      yellow "ℹ $dest already exists, moving to backup directory"
      if ! move_to_backup_dir "$dest"; then
        red "✘ couldn't create backup for $dest"
        return
      fi
    else
      red "✘ $dest already exists"
      return
    fi
  fi

  local link_dir="$(dirname "$full_dest")"
  if [ ! -d "$link_dir" ]; then
    if ! mkdir -p "$link_dir"; then
      red "✘ couldn't create directory $link_dir"
      return
    fi
  fi

  if ln -s "$(pwd)/$source" "$full_dest"; then
    green "✔ $dest has been linked"
  else
    red "✘ $dest link couldn't be created"
  fi
}

link_dotfile "zshrc" ".zshrc"
link_dotfile "zshenv" ".zshenv"
link_dotfile "vimrc" ".vimrc"
link_dotfile "vimrc-vanilla.vim" ".vim/vimrc-vanilla.vim"
link_dotfile "vimrc-extras.vim" ".vim/vimrc-extras.vim"
link_dotfile "gitconfig" ".gitconfig"
link_dotfile "gitignore_global" ".gitignore_global"
link_dotfile "bundle" ".bundle"
link_dotfile "projections.json" ".projections.json"
link_dotfile "alacritty.toml" ".config/alacritty/alacritty.toml"
link_dotfile "ghostty/config" "Library/Application Support/com.mitchellh.ghostty/config"
link_dotfile "Brewfile" ".Brewfile"
link_dotfile "gpg-agent.$(uname -m).conf" ".gnupg/gpg-agent.conf"
