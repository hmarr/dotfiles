#!/bin/sh

red() {
  echo " $(tput setaf 1)$*$(tput setaf 9)"
}
green() {
  echo " $(tput setaf 2)$*$(tput setaf 9)"
}

link_dotfile() {
  source="$1"
  dest="$2"
  full_dest="$HOME/$dest"
  if [ -e "$full_dest" ] || [ -L "$full_dest" ]; then
    if [ -L "$full_dest" ] && [ "$full_dest" -ef "$source" ]; then
      green "✔ $dest is already linked"
    else
      red "✘ $dest already exists"
    fi
  else
    ln -s "$(pwd)/$source" "$full_dest"
    green "✔ $dest has been linked"
  fi
}

link_dotfile "zshrc" ".zshrc"
link_dotfile "zshenv" ".zshenv"
link_dotfile "nvim-init.vim" ".config/nvim/init.vim"
link_dotfile "vimrc-vanilla.vim" ".config/nvim/vimrc-vanilla.vim"
link_dotfile "vimrc-extras.vim" ".config/nvim/vimrc-extras.vim"
link_dotfile "gitconfig" ".gitconfig"
link_dotfile "gitignore_global" ".gitignore_global"
link_dotfile "bundle" ".bundle"

