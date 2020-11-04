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
		call CocAction('doHover')
	endif
endfunction


nnoremap <silent> K :call <SID>show_docs()<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
nnoremap <silent> ]h   :call     CocAction('runCommand', 'clangd.switchSourceHeader')<CR>

inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent><expr><cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

