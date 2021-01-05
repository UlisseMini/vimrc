" https://github.com/junegunn/vim-plug/wiki/tips
" TODO: Test with vim (I use neovim)
if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | q | source $MYVIMRC
  endif
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | q | source $MYVIMRC
  endif
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Intellisense
Plug 'tpope/vim-commentary'                         " Comment stuff out with 'gc' and 'gcc'
Plug 'sheerun/vim-polyglot'                         " Syntax highlighting and indentation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim'

" Themes
Plug 'mhartington/oceanic-next'
Plug 'itchyny/lightline.vim'

call plug#end()

let g:mapleader = ' '

" ========== Configure vim ===========

set sw=2 ts=2 et
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

" ========== Configure coc ==========
" TODO
"

" ========== Configure ripgrep ==========
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
endif

" ========== Colorscheme ==========

syntax on
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
silent! colorscheme OceanicNext

" ========== Keybindings ==========

nn <leader>r :Rg<cr>
nn <leader>f :FZF<cr>


nn <leader>w :w<cr>
nn <leader>e :e<space>
nn <leader>n :bn<cr>
nn <leader>p :bp<cr>
