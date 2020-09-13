set laststatus=2

if has('gui_running')
		set t_Co=256
endif

set noshowmode " unecessary with this plugin

let g:lightline = {
			\ 'colorscheme': 'gruvbox',
			\ 'active': {
			\ 	'left': [['mode', 'paste'], ['readonly', 'filename', 'modified', 'charvaluehex', 'sammy']]
			\ },
			\ 'component': {
			\ 	'charvaluehex': '0x%B',
			\ 	'sammy': 'Hello Sammmy'
			\ },
			\ }
