" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/vimrc-vanilla.vim

" Plugin-related settings
"
" Dependencies ==================================================== {{{

call plug#begin('~/.vim/plugged')

" Core
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf.vim'
"Plug 'sbdchd/neoformat'
Plug 'w0rp/ale'
Plug 'yssl/QFEnter'

" Tools
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-projectionist'

" Languages
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'hmarr/vim-gemfile'
Plug 'rust-lang/rust.vim'
Plug 'myitcv/govim'
Plug 'elixir-lang/vim-elixir'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'hashivim/vim-terraform'

" Other
Plug 'jdkanani/vim-material-theme'

call plug#end()

" }}}

" Plugin Options ================================================== {{{

" Don't hide the ~ characters at the end of the buffer
let g:material_hide_endofbuffer = 0
colorscheme material-theme

" Fuzzy file searching
nnoremap <c-p> :FZF<CR>

if executable('ag')
  " If ag is available, use it for ctrl p, as it's super quick
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" ag.vim mapping message is too long
let g:ag_mapping_message = 0

" Run tests in neovim terminal
let test#strategy = 'vimterminal'

" Make vim not take 1 year to start when using JRuby
let g:ruby_path=system('which ruby')

" Give me my ctrl-c back, you bastard!
let g:ftplugin_sql_omni_key = '<C-j>'

" Tell fzf to use the copy installed by homebrew
set rtp+=/usr/local/opt/fzf

" Use ag to find files for fzf, so .gitignore and friends are honoured
"let $FZF_DEFAULT_COMMAND= 'ag -g ""'
let $FZF_DEFAULT_COMMAND='rg --files --hidden --glob="!.git/" --ignore-file="$HOME/.gitignore_global"'

" Make vim-jsx work for .js files
let g:jsx_ext_required = 0

" Use goimports rather than gofmt
let g:go_fmt_command = 'goimports'

" Read the gometalinter config to disable annoying rules
let g:go_metalinter_command = "gometalinter --config=/Users/harry/.gometalinter"

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
" Clashes with gofmt?
"let g:ale_fix_on_save = 1

let g:neoformat_only_msg_on_error = 1

let g:terraform_fmt_on_save=1
"let omnifunc='go#complete#GocodeComplete'

command GoInfo :echo GOVIMHover()
nnoremap <leader>w :GoInfo<cr>

" }}}

" Testing ========================================================= {{{

nmap <silent> <leader>TS :TestNearest<CR>
nmap <silent> <leader>TT :TestFile<CR>
nmap <silent> <leader>TA :TestSuite<CR>
nmap <silent> <leader>TL :TestLast<CR>
nmap <silent> <leader>TG :TestVisit<CR>

noremap <leader>m :make<CR>

" }}}
