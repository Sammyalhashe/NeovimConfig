
function! search_and_replace#multi_cursor_substitute(r, replace, for) abort range
    silent exec (a:r == 0 ? "" : "'<,'>") . printf('s/\(^\|[ \t]\)\(%s\)\($\|[ \t\n.-=:]\)/\1%s\2\3/g', escape(a:replace, '/'), escape(a:for, '/'))
    nohl
endfunction

command! -nargs=+ -range MultiCursorReplace call search_and_replace#multi_cursor_substitute(<range>, <f-args>)
vnoremap <silent> mc :MultiCursorReplace 
nnoremap <silent> mc :MultiCursorReplace 
