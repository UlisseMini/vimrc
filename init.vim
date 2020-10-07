call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'elmcast/elm-vim'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'rubixninja314/vim-mcfunction'
Plug 'itchyny/lightline.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-surround'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

call plug#end()

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


set sw=2 ts=2
syntax on
filetype plugin indent on
set autoindent smartindent
set ignorecase
set hidden
set mouse=a
set splitbelow

" security
set nomodeline
set modelines=0

let mapleader = " "
let maplocalleader = ","

set background=dark
colo delek

" Ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
let g:rg_derive_root='true'

nn <leader>r :Rg<cr>


nn <leader>w :w<cr>
nn <leader>e :e<space>
nn <leader>n :bn<cr>
nn <leader>p :bp<cr>
nn <leader>an :ALENext<cr>
nn <leader>ap :ALEPrevious<cr>
nn <leader>ad :ALEDetail<cr>
