lua require'lsp'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
" set completeopt=menuone,noinsert,noselect
set completeopt=menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" inoremap <silent><expr> <cr> <sid>handle_cr()

" function! s:handle_cr() abort
"   return pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endfunction

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

" <c-j> will jump backwards to the previous field.
" If you jump before the first field, it will cancel the snippet.
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>
