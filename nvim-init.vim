" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/nvim-init.vim

" Dependencies ==================================================== {{{

call plug#begin('~/.config/nvim/plugged')

" Core
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf.vim'
Plug 'sbdchd/neoformat'
Plug 'w0rp/ale'
Plug 'yssl/QFEnter'

" Tools
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-projectionist'

" Languages
Plug 'keith/swift.vim'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'elixir-lang/vim-elixir'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'hmarr/vim-gemfile'
Plug 'leafgarland/typescript-vim'

" Other
Plug 'jdkanani/vim-material-theme'

call plug#end()

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
set backupdir=~/.config/nvim/backup
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
" Don't hide the ~ characters at the end of the buffer
let g:material_hide_endofbuffer = 0
colorscheme material-theme

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

" Fuzzy file searching
nnoremap <c-p> :FZF<CR>

" }}}

" Plugin Options ================================================== {{{

if executable('ag')
  " If ag is available, use it for ctrl p, as it's super quick
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" ag.vim mapping message is too long
let g:ag_mapping_message = 0

" Run tests in neovim terminal
let test#strategy = "neovim"

" Make vim not take 1 year to start when using JRuby
let g:ruby_path=system('which ruby')

" Give me my ctrl-c back, you bastard!
let g:ftplugin_sql_omni_key = '<C-j>'

" Tell fzf to use the copy installed by homebrew
set rtp+=/usr/local/opt/fzf

" Use ag to find files for fzf, so .gitignore and friends are honoured
"let $FZF_DEFAULT_COMMAND= 'ag -g ""'
let $FZF_DEFAULT_COMMAND='rg --files --hidden'

" Make vim-jsx work for .js files
let g:jsx_ext_required = 0

" Use goimports rather than gofmt
let g:go_fmt_command = "goimports"

" More familiar quickfix and location list shortcuts
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

let g:ale_linters = {
\   'javascript': [],
\}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\}
let g:ale_fix_on_save = 1

let g:neoformat_only_msg_on_error = 1

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
  "autocmd BufWritePre *.js Neoformat
  " Tell coffeescript files to use two spaces for indentation
  autocmd FileType coffee setlocal softtabstop=2 shiftwidth=2 tabstop=4
  " Tell scala files to use two spaces for indentation
  autocmd FileType scala setlocal softtabstop=2 shiftwidth=2 tabstop=4
  " Tell go files to use tabs(!) for indentation
  autocmd FileType go setlocal nolist noexpandtab
  autocmd FileType go setlocal softtabstop=4 shiftwidth=4 tabstop=4
  "autocmd FileType go setlocal makeprg=go\ run\ %
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

" Testing ========================================================= {{{

nmap <silent> <leader>TS :TestNearest<CR>
nmap <silent> <leader>TT :TestFile<CR>
nmap <silent> <leader>TA :TestSuite<CR>
nmap <silent> <leader>TL :TestLast<CR>
nmap <silent> <leader>TG :TestVisit<CR>

noremap <leader>m :make<CR>

" }}}

