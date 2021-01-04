" ==============================================================
" Kabbaj Amine - amine.kabb@gmail.com
" Last modification: 2020-01-03
" ==============================================================


fun! TablineGet() abort " {{{1
    let hi_selected = '%#User4#'
    let hi_cwd = '%#TabLine#'

    let tabline = '%=' . hi_selected . '%( %{TablineBuffer_info()} %)'
    let tabline .= hi_cwd . '%( %{TablineCwd()} %)'
    let tabline .= hi_selected . '%( %{TablineTab()} %)'
    return tabline
endfun
" 1}}}

fun! TablineBuffer_info() abort " {{{1
    let current = bufnr('%')
    let buffers = filter(range(1, bufnr('$')), {i, v ->
    \  buflisted(v) && getbufvar(v, '&filetype') isnot# 'qf'
    \ })
    let index_current = index(buffers, current) + 1
    let modified = getbufvar(current, '&modified') ? '+' : ''
    let count_buffers = len(buffers)
    return index_current isnot# 0 && count_buffers ># 1
    \ ? printf('%s/%s', index_current, count_buffers)
    \ : ''
endfun
" 1}}}

fun! TablineCwd() abort " {{{1
    let cwd = fnamemodify(getcwd(), ':~')
    if cwd isnot# '~/'
        let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
        return cwd
    else
        return ''
    endif
endfun
" 1}}}

fun! TablineTab() abort " {{{1
let count_tabs = tabpagenr('$')
    return count_tabs isnot# 1
                    \ ? printf('T%d/%d', tabpagenr(), count_tabs)
                    \ : ''
endfun
" 1}}}


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

set showtabline=2
set tabline=%!TablineGet()

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
