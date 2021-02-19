" move text with ALT[jk]
if !has("unix")
    nmap <A-j> mz:m+<cr>`z
    nmap <A-k> mz:m-2<cr>`z
    vmap <A-j> :m'>+<cr>`<my`>mzgv`yo`z
    vmap <A-k> :m'<-2<cr>`>my`<mzgv`yo`z
else
    " NOTE: you might have to change these mappings too if you use a mac.
    " Go to a terminal, type the input you want, and copy and paste the result
    " in place of what is here.
    nmap ∆ mz:m+<cr>`z
    nmap ˚ mz:m-2<cr>`z
    vmap ∆ :m'>+<cr>`<my`>mzgv`yo`z
    vmap ˚ :m'<-2<cr>`>my`<mzgv`yo`z
endif
