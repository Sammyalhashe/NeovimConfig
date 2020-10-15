function! JSRunner() abort
	!node "%:p"
endfunction

map <leader>r :call JSRunner()<CR>

" folding
set foldmethod=syntax
set foldcolumn=1
let javaScript_fold=1
set foldlevelstart=99
