" script for auto-closing brackets on enter
" TODO make it check if the last thing is a bracket
" so I can press enter anytime
let g:bracketMap = {
    \ '{' : '}',
    \ '(' : ')',
    \ '[' : ']',
    \ }

function! s:CloseBracketSpecific(bracket)
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return a:bracket . "\<Enter>" . g:bracketMap[a:bracket] . ";\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return a:bracket . "\<Enter>" . g:bracketMap[a:bracket] . ");\<Esc>O"
    else
        return a:bracket . "\<Enter>" . g:bracketMap[a:bracket] . "\<Esc>O"
    endif
endfunction

" setting up the mappings
for k in keys(g:bracketMap)
    exec printf("inoremap <expr> %s<Enter> <SID>CloseBracketSpecific('%s')", k, k)
endfor
