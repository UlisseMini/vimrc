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
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'ferrine/md-img-paste.vim'
Plug 'github/copilot.vim'
Plug 'easymotion/vim-easymotion'
Plug 'UlisseMini/gruvbox'

" Plug 'codota/tabnine-vim'

" Themes
Plug 'mhartington/oceanic-next'
Plug 'NLKNguyen/papercolor-theme'
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
set relativenumber
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

" Make markdown preview open url in a new window
" function OpenBrowser(url)
"   execute "!firefox --new-window " . a:url
" endfunction
" let g:mkdp_browserfunc = "OpenBrowser"

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 1

" ========== Markdown image paste ========== 

autocmd FileType markdown nmap <buffer><silent> <leader>mp :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = '.'
" let g:mdip_imgname = 'image'

" ========== Configure coc ==========
" TODO: Configure more stuff https://github.com/neoclide/coc.nvim

" Svelte
let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_use_typescript = 1

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

" Code actions (ie. auto import / quickfix)
nmap <leader>ca <Plug>(coc-codeaction)


" Symbol renaming.
nmap <leader>cr <Plug>(coc-rename)

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
set background=dark
silent! colorscheme gruvbox
" silent! colorscheme PaperColor
" silent! colorscheme delek

" ========== Keybindings ==========

nn <leader>r :Rg<cr>
nn <leader>f :FZF<cr>


nn <leader>w :w<cr>
nn <leader>e :e<space>
nn <leader>n :bn<cr>
nn <leader>p :bp<cr>

" manim
nn <leader>mp :!manim -pqm % <cword><cr>
nn <leader>ms :!manim -psqm % <cword><cr>
