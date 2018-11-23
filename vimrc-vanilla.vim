" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/vimrc-vanilla.vim

" Settings that work with any flavour of vim, and don't rely on plugins

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
" Don't make backup files
set nobackup
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
" Don't open the scratch window when c-x c-o autocompleting
set completeopt-=preview
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" Show line numbers
set number

" Highlight 80th column so code can still be pretty in full-screen terminals
if exists("&colorcolumn")
  set colorcolumn=80
endif

" Make it pretty
set termguicolors
set background=dark

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
noremap <c-h>  <c-w>h
noremap <c-j>  <c-w>j
noremap <c-k>  <c-w>k
noremap <c-l>  <c-w>l
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
nnoremap ∆ :m+<CR>==
nnoremap ˚ :m-2<CR>==
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv
vnoremap ∆ :m'>+<CR>gv=gv
vnoremap ˚ :m-2<CR>gv=gv

" Write files with sudo if opened without priviliedges
cmap w!! w !sudo tee % >/dev/null

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

" Per-directory vimrc files
if !empty($LOCAL_VIMRC)
  set secure exrc
endif

" }}}
