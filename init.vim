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
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'

" Colors
Plug 'morhetz/gruvbox'

" Status line
Plug 'itchyny/lightline.vim'

call plug#end()

source ~/.config/nvim/config.vim
source ~/.config/nvim/lightline_conf.vim
