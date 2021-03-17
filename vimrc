" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/nvim-init.vim

source ~/.vim/vimrc-vanilla.vim
if $CODESPACES != 'true'
  source ~/.vim/vimrc-extras.vim
endif

set backup
set backupdir=~/.vim/backup
