" vim: foldmethod=marker

" set default folder
let g:DIR = expand('~/.config/nvim/')

" set clipboard
set clipboard^=unnamed,unnamedplus

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
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'

" Autocomplete
Plug 'ervandew/supertab'

" Colors
Plug 'morhetz/gruvbox'

" Status line
Plug 'itchyny/lightline.vim'

call plug#end()

" python
let g:python = '/usr/bin/python3.8'
if filereadable(g:python)
	let g:python3 = g:python
endif

source ~/.config/nvim/config.vim
source ~/.config/nvim/plugin_confs/lightline_conf.vim
source ~/.config/nvim/plugin_confs/ctrlp_conf.vim
