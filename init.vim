" vim: foldmethod=marker

let s:currdir = expand('<sfile>:h')

set backspace=indent,eol,start

" terminal colors
if $TERM == "screen-256color" || $TERM == "xterm-256color"
	set t_C0=256
	set t_8f=^[[38;2;%lu;%lu;%lum
	set t_8b=^[[48;2;%lu;%lu;%lum
endif

" set default folder
let g:DIR = expand('~/.config/nvim/')

" set clipboard
set clipboard^=unnamed,unnamedplus

" Set clipboard for windows
let s:clip = '/c/Windows/System32/clip.exe'
if executable(s:clip)
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
	augroup END
endif

" set the os
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

if has('nvim')
		if empty(glob(s:currdir . '/autoload/plug.vim'))
				silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
										\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				autocmd VimEnter * PlugInstall
		endif
else
		if empty(glob('~/.vim/autoload/plug.vim'))
				silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
										\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				autocmd VimEnter * PlugInstall
		endif
endif

" Plugins

call plug#begin()

function! DoRemote(arg)
		UpdateRemotePlugins
endfunction

" Misc plugins
Plug 'glepnir/dashboard-nvim'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'https://gitlab.com/Sammyalhashe/sammys-vim-agenda'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'pseewald/vim-anyfold', { 'commit': '4c30bbd9f4a7ec92f842b612c9bd620bd007e0ed' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'moveaxesp/bdeformat'
Plug 'romainl/vim-qf'
Plug 'onsails/lspkind-nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'gauteh/vim-cppman'
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/utl.vim'
Plug 'inkarkat/vim-SyntaxRange'

" Autocomplete/lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'norcalli/snippets.nvim'

" Colors
Plug 'morhetz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'arcticicestudio/nord-vim'
Plug 'liuchengxu/space-vim-theme'

call plug#end()

" check if bb is there
if filereadable(s:currdir)
    call Sourcer#Source(s:currdir, 'bb.vim')
else
    let g:python = '/usr/bin/python3.8'
    if filereadable(g:python)
        let g:python3 = g:python
    endif
endif

" Source rest of config
call Sourcer#PlugInstallIfPluggedDoesntExist()
call Sourcer#Source(s:currdir, 'config.vim')


