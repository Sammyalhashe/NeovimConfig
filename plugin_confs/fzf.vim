let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
nnoremap <leader>e :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>li :Lines<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>? :Rg<CR>

if has('nvim')
	" let g:fzf_layout = {'window' : 'call FloatingFZF()'}
endif


function! s:build_quickfix_list(lines)
  echo 'qfix thing'
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! FloatingFZF()
	" let buf = nvim_create_buf(v:false, v:true)
	call setbufvar(buf, '&signcolunm', 'no')

	let height = float2nr(&lines * 0.4) " 40% of screen
	let width = float2nr(&lines * 0.8) " 80% of screen
	let horizontal = float2nr((&column - width) / 2)
	let vertical = float2nr(&lines * 0.1)

	let opts = {
				\ 'relative': 'editor',
				\ 'row': vertical,
				\ 'col': horizontal,
				\ 'width': width,
				\ 'height': height,
				\ 'anchor': 'NW',
				\ 'style': 'minimal'
				\ }
    return opts
endfunction

