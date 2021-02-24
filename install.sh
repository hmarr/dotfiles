#!/bin/sh

red() {
  echo " $(tput setaf 1)$*$(tput setaf 9)"
}

yellow() {
  echo " $(tput setaf 3)$*$(tput setaf 9)"
}

green() {
  echo " $(tput setaf 2)$*$(tput setaf 9)"
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
    red "✘ $dest already exists"
    return
  fi

  local link_dir="$(dirname $full_dest)"
  if [ ! -d "$link_dir" ]; then
    mkdir -p "$link_dir"
    if [ $? -ne 0 ]; then
      red "✘ couldn't create directory $link_dir"
      return
    fi
  fi

  ln -s "$(pwd)/$source" "$full_dest"
  if [ $? -eq 0 ]; then
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

