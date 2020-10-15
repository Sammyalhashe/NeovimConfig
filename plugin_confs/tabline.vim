function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tabnr = i + 1
		let winnr = tabepagewinnr(tabnr)
		let buflist = tabpagebuflist(tabnr)
		let bufnr = buflist[winnr - 1]
		let bufname = fnamemodify(bufname(bufnr), ':t')

		let s .= '%' . tabnr . 'T'
		let s .= (tabnr == tabpagenr ? '%#TabLineSel#' : '%TabLine#')
		let s .= ' ' . tabnr

		let n = tabepagewinnr(tabnr, '$')
		if n > 1 | let s .= ':' . n | endif

		let s .= empty(bufname) ? ' [No Name] ' : ' ' . bufname . ' '

		let bufmodified = getbufvar(bufnr, "%mod")
		if bufmodified | let s .= '+ ' | endif
	endfor
	
	let s .= '%#TabLineFill#'
	return s
endfunction

set tabline=%!Tabline()
