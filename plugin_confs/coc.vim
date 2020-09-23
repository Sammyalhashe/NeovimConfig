set updatetime=300
set shortmess+=c
set signcolumn=yes

nnoremap <leader>n <Plug>(coc-rename)

nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

function! s:show_docs()
	if (index(['vim', 'help'], &filetype) >= 0)
		execute 'h ' . expand('<cword>')
	else
		CocAction('doHover')
	endif
endfunction


nnoremap <silent> K :call <SID>show_docs()<CR>


inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent><expr><cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

