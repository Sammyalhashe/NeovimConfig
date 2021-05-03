" function! s:JbzCppMan()
"     let old_isk = &iskeyword
"     setl iskeyword+=:
"     let str = expand("<cword>")
"     let &l:iskeyword = old_isk
"     execute 'Man ' . str
" endfunction

" function
" command! JbzCppMan :call s:JbzCppMan()

" augroup CPPMAN
"     au!
"     au FileType cpp nnoremap <buffer>K :JbzCppMan<CR>
" augroup END
