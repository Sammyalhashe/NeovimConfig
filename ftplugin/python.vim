" not required in python files
autocmd! FileType python setl nosmartindent

autocmd! FileType python setl colorcolumn=80 " for PEP

function! PyRunner() abort
	!/usr/bin/python3.8 "%:p"
endfunction

map <leader>r :call PyRunner()<CR>

" folding
set foldmethod=indent
set foldcolumn=1
set foldlevelstart=99
setl foldnestmax=2
