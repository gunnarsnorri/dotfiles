" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

syntax on
set backspace=indent,eol,start
let mapleader=" "
map <leader>8 :PymodeLintAuto<CR>
map <leader>k :E<CR>
map <leader>ma :!make all<CR>
map <leader>M :!make<CR>
map <leader>mc :!make clean<CR>
let g:netrw_liststyle=3
map <leader>" caw "<ESC>pa"<ESC>ee
map <leader>' caw '<ESC>pa'<ESC>ee
map <leader>t :w<CR>:!xelatex %<CR>

let g:javascript_enable_domhtmlcss=1

set number
set showcmd
set cursorline
set wildmenu
set lazyredraw

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on
    au BufRead,BufNewFile *.pde set filetype=arduino
    au BufRead,BufNewFile *.ino set filetype=arduino
    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
    autocmd FileType cpp,c,cxx,h,hpp,python,sh  setlocal cc=120
    autocmd FileType python  setlocal cc=80
    autocmd BufWritePre * StripWhitespace

endif

" For everything else, use a tab width of 4 space chars.
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4.
set softtabstop=4   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.


" arduino syntax
map <leader>ai migg=G'i

let g:pymode_rope = 0
let g:pymode_python = 'python3'

map <leader>y "*y
map <leader>p "*p

" YouCompleteMe
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'python': 1
      \}
let g:ycm_global_ycm_extra_conf = '/home/gunsno/svn/SMCU/source/.ycm_extra_conf.py'
