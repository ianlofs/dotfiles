" Pathogen stuff
execute pathogen#infect()
syntax on
filetype plugin indent on
set sessionoptions-=options

" Im learning
Helptags

" Always open nerdTREE
autocmd vimenter * NERDTree

" I like line numbers
set number

" Go autocomplete
call deoplete#enable()

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" tab and shift width 4
set ts=4
set sw=4
set expandtab

" enable mouse
set ttyfast
set mouse=a

" go imports 
let g:go_fmt_command = "goimports"
