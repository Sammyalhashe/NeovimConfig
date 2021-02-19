function! s:BDEFmt(afe)
    let _ = system("bde-format -i " . expand('%:p'))
    if a:afe
        edit
    endif
endfunction

augroup BDE
    let autoformat_enabled = get(g:, 'enable_autoformat', 0)
    autocmd!
    autocmd FileType cpp,c map <C-f> :call s:BDEFmt(v:false)<CR>:edit<CR>
    autocmd BufWritePre * if count(['c', 'cpp'], &filetype) &&
                \ autoformat_enabled
                \ | call s:BDEFmt(v:true)
                \ | endif
augroup END
