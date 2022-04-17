" vim: foldmethod=marker

let currdir = expand('<sfile>:h')

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

" set the os
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "Windows"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
        if has('wsl')
            let g:wsl = v:true
        else
            let g:wsl = v:false
        endif
	endif
endif

if has('nvim')
		if empty(glob(currdir . '/autoload/plug.vim'))
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
call plug#begin('~/.dotfiles/nvim/plugged')

function! DoRemote(arg)
		UpdateRemotePlugins
endfunction

" Misc plugins
Plug 'jkramer/vim-narrow'
Plug 'glepnir/dashboard-nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'pseewald/vim-anyfold', { 'commit': '4c30bbd9f4a7ec92f842b612c9bd620bd007e0ed' }
Plug 'moveaxesp/bdeformat'
Plug 'romainl/vim-qf'
Plug 'onsails/lspkind-nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'itchyny/lightline.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'folke/trouble.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}

" Orgmode
Plug 'nvim-orgmode/orgmode'
Plug 'akinsho/org-bullets.nvim'
Plug 'vim-scripts/utl.vim'
Plug 'inkarkat/vim-SyntaxRange'

" Autocomplete/lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Colors
Plug 'morhetz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'arcticicestudio/nord-vim'
Plug 'liuchengxu/space-vim-theme'
Plug 'jnurmine/Zenburn'

call plug#end()

let g:bb = v:false

" check if bb is there
if filereadable(currdir . "/bb.vim")
    let g:bb = v:true
    call Sourcer#Source(currdir, 'bb.vim')
else
    let g:python = '/usr/bin/python3.8'
    if filereadable(g:python)
        let g:python3 = g:python
    endif
endif

let g:ITERM2_PRESET=""
if g:os == 'Darwin' && filereadable(expand('~/.config/iterm2/AppSupport/Scripts/AutoLaunch/ITERM2_PRESET'))
    let preset = readfile(expand('~/.config/iterm2/AppSupport/Scripts/AutoLaunch/ITERM2_PRESET'), '', 1)
    if len(preset) != 0
        let g:ITERM2_PRESET = preset[0]
    endif
endif

" Source rest of config
call Sourcer#PlugInstallIfPluggedDoesntExist()
call Sourcer#Source(currdir, 'config.vim')
call Sourcer#Source(currdir, 'neovide.vim')


