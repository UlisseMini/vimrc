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
Plug 'antoinemadec/coc-fzf'
Plug 'tpope/vim-surround'
Plug 'luochen1990/rainbow'
Plug 'timmyjose-projects/lox.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'lervag/vimtex'
Plug 'jxnblk/vim-mdx-js'

" Plug 'codota/tabnine-vim'

" Themes
Plug 'mhartington/oceanic-next'
Plug 'itchyny/lightline.vim'

" Lean
Plug 'Julian/lean.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'

call plug#end()

let g:mapleader = ' '
let g:maplocalleader = ','

" ========== Configure vim ===========

set sw=2 ts=2 et
filetype plugin indent on
set autoindent smartindent
set ignorecase
set number
set hidden
set mouse=a
set splitbelow

set undodir=~/.config/nvim/undodir
set undofile

" security
set nomodeline
set modelines=0

let mapleader = " "

" ========== Rainbow ===========
let g:rainbow_active = 1

" ========== Markdown Preview ===========
" browser is a script in my $PATH that runs firefox --new-window "$@"
let g:mkdp_browser = "browser"

" ========== Configure coc ==========
" TODO: Configure more stuff https://github.com/neoclide/coc.nvim

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" https://parceljs.org/hmr.html#safe-write
set backupcopy=yes

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

  " Update signature help on jump placeholder.
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


autocmd CursorHold * silent call CocActionAsync('highlight')


" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" ========== Configure ripgrep ==========
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
endif

" ========== Colorscheme ==========

syntax on
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
silent! colorscheme OceanicNext
" silent! colorscheme delek

" ========== Keybindings ==========

nn <leader>r :Rg<cr>
nn <leader>f :FZF<cr>


nn <leader>w :w<cr>
nn <leader>e :e<space>
nn <leader>n :bn<cr>
nn <leader>p :bp<cr>
