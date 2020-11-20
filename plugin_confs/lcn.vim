set hidden
set omnifunc=syntaxcomplete#Complete
set completefunc=LanguageClient#complete
set complete+=kspell
set completeopt+=menuone,noselect,noinsert
set completeopt-=preview
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

" let g:LanguageClient_serverCommands = {
"     \ 'cpp': ['clangd']
"     \ }

" nmap <F5> <Plug>(lcn-menu)
" nmap <silent>K <Plug>(lcn-hover)
" nmap <silent> gd <Plug>(lcn-definition)
" nmap <silent> <F2> <Plug>(lcn-rename)

let g:lsc_server_commands = { 
            \ 'cpp': {
            \ 'command': 'clangd',
            \ 'log_level': -1,
            \ 'suppress_stderr': v:true,
            \ }
        \ }
let g:lsc_enable_autocomplete = v:true
" let g:lsc_auto_map = v:true
let g:lsc_auto_map = {
 \  'GoToDefinition': 'gd',
 \  'FindReferences': 'gr',
 \  'Rename': 'gR',
 \  'ShowHover': 'K',
 \  'FindCodeActions': 'ga',
 \  'Completion': 'omnifunc',
 \}

inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
