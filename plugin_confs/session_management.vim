function! MksOnCurrent() abort
    exec printf("mks! %s", v:this_session)
endfunction

if !(v:this_session ==? '')
    augroup session_management
        autocmd!
        autocmd BufWritePre * call MksOnCurrent()
    augroup END
endif
