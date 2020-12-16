function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tabnr = i + 1
		let winnr = tabpagewinnr(tabnr)
		let buflist = tabpagebuflist(tabnr)
		let bufnr = buflist[winnr - 1]
		let bufname = fnamemodify(bufname(bufnr), ':t')

		let s .= '%' . tabnr . 'T'
		let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%TabLine#')
		let s .= ' ' . tabnr

		let n = tabpagewinnr(tabnr, '$')
		if n > 1 | let s .= ':' . n | endif

		let s .= empty(bufname) ? ' [No Name] ' : ' ' . bufname . ' '

		let bufmodified = getbufvar(bufnr, "%mod")
		if bufmodified | let s .= '+ ' | endif
	endfor
	
	let s .= '%#TabLineFill#'
	return s
endfunction

set tabline=%!Tabline()

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <silent><leader>0 :tablast<cr>
