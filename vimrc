" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/blob/main/vimrc

source ~/.vim/vimrc-vanilla.vim

if !isdirectory(expand("~/.vim/backup"))
  silent! execute "!mkdir -p ~/.vim/backup"
endif
set backup
set backupdir=~/.vim/backup

if filereadable(expand("~/.vim/autoload/plug.vim"))
  source ~/.vim/vimrc-extras.vim
endif
