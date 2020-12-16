lua require'lsp'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

inoremap <silent><expr> <cr> <sid>handle_cr()

function! s:handle_cr() abort
  return pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endfunction
