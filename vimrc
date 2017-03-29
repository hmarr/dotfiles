" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/vimrc

" Vundle Dependencies ============================================= {{{

set nocompatible  " be iMproved
filetype off      " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Core
Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'JazzCore/ctrlp-cmatcher'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-endwise'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'matchit.zip'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'kana/vim-textobj-user'

" Tools
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'janko-m/vim-test'

" Languages
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'tpope/vim-rails'
Plugin 'elzr/vim-json'
Plugin 'othree/html5.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-markdown'
Plugin 'exu/pgsql.vim'
"Plugin 'thoughtbot/vim-rspec'
Plugin 'elixir-lang/vim-elixir'
Plugin 'othree/yajs.vim'
Plugin 'hmarr/vim-gemfile'
Plugin 'leafgarland/typescript-vim'
Plugin 'lambdatoast/elm.vim'
Plugin 'hashivim/vim-terraform'

Plugin 'flazz/vim-colorschemes'

call vundle#end()            " required
filetype plugin indent on    " required

" }}}

" Basic Settings ================================================== {{{

" Enable syntax highlighting
syntax on
" Use indent level from previous line
set autoindent
" Replace tabs with spaces
set expandtab
" A tab shows as 2 columns wide
set tabstop=2
" How many spaces to indent text with (using << and >>)
set shiftwidth=2
" How many columns to insert when I press TAB
set softtabstop=2
" Highlight matching brackets
set showmatch
" Show line and column in status bar
set ruler
" Search as you type
set incsearch
" Don't highlight search results
set nohls
" Case insensitive searches
set ignorecase
" Case sensitive searches when uppercase characters are used
set smartcase
" Scroll before I reach the window edge
set scrolloff=5
" Use the mouse in terminal emulators that support it
set mouse=a
" Only use one space when joining lines
set nojoinspaces
" Up the undo / redo limit
set history=1000
" Show options during tab completion
set wildmenu
" Always show the statusline
set laststatus=2
" Necessary to show unicode glyphs
set encoding=utf-8
" Make backup files
set backup
" Location of backup files
set backupdir=~/.vim/backup
" Fuck swap files
set noswapfile
" Show tabs and trailing whitespace
set list
set listchars=tab:▸\ ,trail:•
" Ignore crap in wildcard completion
set wildignore+=*.o,*.obj,.git,*.pyc,node_modules
" Make backspace sane (e.g. don't stop backspacing at the start of inserted text)
set backspace=indent,eol,start
" Enable filetype settings (inc. indentation), files in .vim/ftplugin are read
filetype off
filetype plugin indent on
" Set terminal title to current buffer
set title
let &titleold=getcwd()
" Don't autocomplete full names, only longest prefix
set completeopt+=longest
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Highlight 80th column so code can still be pretty in full-screen terminals
if exists("&colorcolumn")
    set colorcolumn=80
endif

" Solarized is awesome
colorscheme solarized
" Light solarized colour scheme
set background=light

" Disable slow regex engine for faster syntax highlighting
if v:version >= 704
  set regexpengine=1
endif

" }}}

" Mappings ======================================================== {{{

let mapleader=','

" Make j and down keys move down one row even when lines are wrapped
nnoremap j gj
nnoremap <DOWN> gj
" Make k and up keys move up one row even when lines are wrapped
nnoremap k gk
nnoremap <UP> gk
" Make down key move down one row in insert mode even when lines are wrapped
inoremap <DOWN> <C-O>gj
" Make up key move up one row in insert mode even when lines are wrapped
inoremap <UP> <C-O>gk

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Emacs-style start and end of line
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>v <c-w>v

" Make Y yank rest of line, like D and C
nnoremap Y y$

" Cut, copy and paste using the real clipboard
vnoremap <leader>y "+y
vnoremap <leader>x "+x
nnoremap <leader>p "+gp
nnoremap <leader>P "+gP

" Ag shortcut. <SPACE> there to keep space being stripped :|
nnoremap <leader>a :Ag!<SPACE>

" Substitute
nnoremap <leader>s :%s//g<left><left>

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Less chording
nnoremap ; :

" Quick return in insert mode
inoremap <c-cr> <esc>A<cr>
inoremap <s-cr> <esc>O

" Space toggles folds
nnoremap <space> za
vnoremap <space> za

" Select the contents of the current line, excluding indentation
nnoremap vv ^vg_

" Switch tabs easily
nnoremap ˙ gT
nnoremap ¬ gt
nnoremap <esc>h gT
nnoremap <esc>l gt

" Shortcuts for enabling / disabling search highlighting
nnoremap ,hl :set hls<CR>
nnoremap ,nhl :set nohls<CR>

" Use alt + {j,k} for moving lines up and down
nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv

" Write files with sudo if opened without priviliedges
cmap w!! w !sudo tee % >/dev/null

" }}}

" Plugin Options ================================================== {{{

" Actually good ctrl-p matcher, more like cmd-t
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

if executable('ag')
  " If ag is available, use it for ctrl p, as it's super quick
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" ag.vim mapping message is too long
let g:ag_mapping_message = 0

" Posh airline glyphs
let g:airline_powerline_fonts = 1

" Run tests in neovim terminal
"let test#strategy = "neovim"

" Make vim not take 1 year to start when using JRuby
let g:ruby_path=system('which ruby')

" Give me my ctrl-c back, you bastard!
let g:ftplugin_sql_omni_key = '<C-j>'

" }}}

" Autocommands ==================================================== {{{

if has("autocmd")
    " Clean up whitespace on save
    autocmd BufWritePre * CleanWhitespace
    " Tell python files to use four spaces for indentation
    autocmd FileType python setlocal softtabstop=4 shiftwidth=4 tabstop=4
    " Tell ruby files to use two spaces for indentation
    autocmd FileType ruby setlocal softtabstop=2 shiftwidth=2 tabstop=4
    "autocmd FileType ruby let b:delimitMate_expand_cr = 0
    " Tell json files to use two spaces for indentation
    autocmd FileType json setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell javascript files to use two spaces for indentation
    autocmd FileType javascript setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell coffeescript files to use two spaces for indentation
    autocmd FileType coffee setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell scala files to use two spaces for indentation
    autocmd FileType scala setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell go files to use tabs(!) for indentation
    autocmd FileType go setlocal nolist noexpandtab
    autocmd FileType go setlocal softtabstop=4 shiftwidth=4 tabstop=4
    autocmd FileType go setlocal makeprg=go\ run\ %
    " Makefiles use tabs only
    autocmd FileType make setlocal noexpandtab
    " gitconfig uses tabs when `git config --global ...` is used
    autocmd FileType gitconfig setlocal noexpandtab

    " Use {{{ - }}} style folds
    autocmd FileType css setlocal foldmethod=marker
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType zsh setlocal foldmethod=marker

  autocmd BufNewFile,BufRead Jarfile set filetype=ruby
endif

" }}}

" Misc ============================================================ {{{

" Remove trailing whitespace
function! <SID>CleanWhitespace()
    " Preparation - save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command CleanWhitespace call <SID>CleanWhitespace()


" Source a global configuration file if available
if filereadable(expand("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif

" Reason
if !empty(system('which opam'))
  " Merlin plugin
  let s:ocamlmerlin=substitute(system('opam config var share'),'\n$','','') . "/merlin"
  execute "set rtp+=".s:ocamlmerlin."/vim"
  execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
  let g:syntastic_ocaml_checkers=['merlin']

  " Reason plugin which uses Merlin
  let s:reasondir=substitute(system('opam config var share'),'\n$','','') . "/reason"
  execute "set rtp+=".s:reasondir."/editorSupport/VimReason"
  let g:syntastic_reason_checkers=['merlin']
else
endif

" }}}

" Testing ========================================================= {{{

" Rspec.vim mappings
"map <Leader>TT :call RunCurrentSpecFile()<CR>
"map <Leader>TS :call RunNearestSpec()<CR>
"map <Leader>TL :call RunLastSpec()<CR>
"map <Leader>TA :call RunAllSpecs()<CR>

nmap <silent> <leader>TS :TestNearest<CR>
nmap <silent> <leader>TT :TestFile<CR>
nmap <silent> <leader>TA :TestSuite<CR>
nmap <silent> <leader>TL :TestLast<CR>
nmap <silent> <leader>TG :TestVisit<CR>

noremap <leader>m :make<CR>

" }}}

