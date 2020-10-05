nn <leader>r :!go run .<cr>
nn <leader>b :!go build .<cr>
nn <leader>t :!go test .<cr>
nn <leader>gh :GoDoc<space>

set noexpandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" vim-go is shit, ale is life
let g:go_fmt_autosave = 0

let g:ale_fix_on_save = 1
let g:ale_fixers = {'go': ['goimports']}
