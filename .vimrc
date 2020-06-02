" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()



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
    autocmd FileType cpp,c,cxx,h,hpp set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType cpp,c,cxx,h,hpp,python,sh  setlocal cc=80
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

let g:pymode_python = 'python3'
" turn on rope
let g:pymode_rope = 1

map <leader>y "*y
map <leader>p "*p

" vim-lsp
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'h', 'hpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType h setlocal omnifunc=lsp#complete
        autocmd FileType hpp setlocal omnifunc=lsp#complete
    augroup end
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <leader>ld <plug>(lsp-peek-definition)
    nmap <buffer> <f2> <plug>(lsp-rename)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()
let g:lsp_diagnostics_echo_cursor = 1

map <leader>lf :LspDocumentFormat<CR>
