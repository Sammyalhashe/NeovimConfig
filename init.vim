" vim: foldmethod=marker


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
		if empty(glob(g:DIR . '/autoload/plug.vim'))
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
Plug 'https://gitlab.com/Sammyalhashe/sammys-vim-agenda'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" Plug 'airblade/vim-gitgutter'
" Plug 'jiangmiao/auto-pairs'
Plug 'pseewald/vim-anyfold', { 'commit': '4c30bbd9f4a7ec92f842b612c9bd620bd007e0ed' }
Plug 'ryanoasis/vim-devicons', { 'tag': 'v0.10.0' }
" Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/goyo.vim'
Plug 'moveaxesp/bdeformat'
Plug 'romainl/vim-qf'

" Autocomplete + linting DONE: check if allowed (abid uses it)
" Plug 'ervandew/supertab'
" Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim'
" Plug 'neoclide/coc.nvim', { 'tag': 'v0.0.74' }
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" Plug 'natebosch/vim-lsc'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" Colors
Plug 'morhetz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'arcticicestudio/nord-vim', { 'tag': 'v0.11.0'  }

" Status line
" Plug 'itchyny/lightline.vim'

call plug#end()

" python
let g:python = '/usr/bin/python3.8'
if filereadable(g:python)
	let g:python3 = g:python
endif

source ~/.config/nvim/config.vim
source ~/.config/nvim/plugin_confs/lightline_conf.vim
source ~/.config/nvim/plugin_confs/fzf.vim
" source ~/.config/nvim/plugin_confs/ctrlp_conf.vim
" source ~/.config/nvim/plugin_confs/ale_config.vim
" source ~/.config/nvim/plugin_confs/coc.vim
source ~/.config/nvim/plugin_confs/lsp.vim
source ~/.config/nvim/plugin_confs/treesitter.vim
source ~/.config/nvim/plugin_confs/statusline.vim
source ~/.config/nvim/plugin_confs/tabline.vim
source ~/.config/nvim/plugin_confs/close_brackets.vim
