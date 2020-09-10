" vim: foldmethod=marker

" leader key
let mapleader=";"
let maplocalleader="\<space>"

" terminal mapping
tnoremap <ESC> <C-\><C-n>

" nvim is always nocompatible -> better safe than sorry
set nocompatible

set termguicolors

" Disable highlights with <leader><cr>
map <silent> <leader><cr> :noh<cr>

" enable syntax highlighting
syntax enable

" enable filetype plugins
filetype plugin on
filetype indent on

" more characters will be sent ot the screen for redrawing
set ttyfast

" time waited for key press(es) to complete.
" It makes for a faster key response
set timeout
set timeoutlen=50

" make backspace behave properly in insert mode
" NOTE: Not necessary in nvim it seems
" set backspace=indent,eol,start

" a better menu in command mode
set wildmenu
set wildmode=longest:full,full

" hide buffesr instead of closing them even if they contain unsaved changed
set hidden

" disable softwrap for lines
set nowrap

" always display status line
set laststatus=2

" enable numbers
set number " relativenumber

" highlight current line
set cursorline

" new splits will be at the bottom or to the right of the screen
set splitbelow
set splitright

" always set autoindenting on
set autoindent
set smartindent

" while searching shows per character typed
set incsearch

" do you want to highlight searches?
" set hlsearch

" searches are case sensitive unless they contain at least one capital letter
set ignorecase
set smartcase

" background
set background=dark

" colorscheme
colorscheme desert

" clipboard
set clipboard^=unnamed

" command history
set history=500

" easy mapping for executing shell commands
nnoremap ! :!

" mouse enable
set mouse=a

" detects changes to current file
set autoread

" don't redraw while executing macros (for performance)
set lazyredraw

" for regex, turn magic on
set magic

" show matching brackets when hovering
set showmatch

" no annoying sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" set utf8 as standard encoding
set encoding=utf8
scriptencoding utf8

" use unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in git
set nobackup
set nowb
set noswapfile

" be smart when using tabs
set smarttab
set tabstop=4

" set 7 lines to the cursor when moving vertically
set so=7

" Return to last edit position when opening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" remap tabs when going through selection lists
" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" inoremap <expr> <tab> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

" smart way to move between splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-k> <C-w>k
map <C-l> <C-w>l

