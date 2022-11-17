" Author: Harry Marr <harry@hmarr.com>
" Source: https://github.com/hmarr/dotfiles/tree/master/vimrc-extras.vim

" Plugin-related settings
"
" Dependencies ==================================================== {{{

call plug#begin('~/.vim/plugged')

" Tools
Plug 'vim-test/vim-test'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'yssl/QFEnter'

" Languages
Plug 'hashivim/vim-terraform'
Plug 'hmarr/vim-gemfile'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'

" Other
Plug 'jdkanani/vim-material-theme'

call plug#end()

" }}}

" Plugin Options ================================================== {{{

" Don't hide the ~ characters at the end of the buffer
let g:material_hide_endofbuffer = 0

if $TERMINAL_THEME != "light"
  colorscheme material-theme
endif

" Fuzzy file searching
nnoremap <c-p> :FZF<CR>

" Use rg to search for the word under the cursor
nnoremap <leader>a :Rg! <C-R><C-W><CR>
" Use rg to search within files. <SPACE> there to keep space being stripped
nnoremap <leader>A :Rg!<SPACE>

" Run tests in neovim terminal
let test#strategy = 'vimterminal'

" Make vim not take 1 year to start when using JRuby
let g:ruby_path=system('which ruby')

" Give me my ctrl-c back, you bastard!
let g:ftplugin_sql_omni_key = '<C-j>'

" Tell fzf to use the copy installed by homebrew
set rtp+=/usr/local/opt/fzf
set rtp+=/opt/homebrew

" Use ripgrep to find files for fzf, so .gitignore and friends are honoured
let $FZF_DEFAULT_COMMAND='rg --files --hidden --glob="!.git/" --ignore-file="$HOME/.gitignore_global"'

" Make vim-jsx work for .js files
let g:jsx_ext_required = 0

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

let g:terraform_fmt_on_save=1

augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
      \ 'whitelist': ['go'],
      \ })
  autocmd FileType go setlocal omnifunc=lsp#complete
  autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
  autocmd FileType go nmap <buffer> <leader>w <plug>(lsp-hover)
augroup END

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': 'ℹ'}

let g:neoformat_only_msg_on_error = 1

augroup Neoformat
  autocmd BufWritePre *.go Neoformat
  autocmd BufWritePre *.tf Neoformat
augroup END

" }}}

" Testing ========================================================= {{{

nmap <silent> <leader>TS :TestNearest<CR>
nmap <silent> <leader>TT :TestFile<CR>
nmap <silent> <leader>TA :TestSuite<CR>
nmap <silent> <leader>TL :TestLast<CR>
nmap <silent> <leader>TG :TestVisit<CR>

noremap <leader>m :make<CR>

" }}}
