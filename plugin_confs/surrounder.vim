let g:mapping_dict = {
            \ '(' : ')',
            \ '[' : ']',
            \ '{' : '}',
            \ '<' : '>'
            \ }

function! plugin_confs#surrounder#surround(char) abort
    let l:ender = a:char
    if has_key(g:mapping_dict, a:char)
        let l:ender = g:mapping_dict[a:char]
    endif
    exe 'norm viwc' . a:char 
    exe 'norm p"'
    exe 'norm a' . l:ender
endfunction


nnoremap <silent> surr :call plugin_confs#surrounder#surround(input('Surround with: '))<CR>
vnoremap <silent> surr :call plugin_confs#surrounder#surround(input('Surround with: '))<CR>
