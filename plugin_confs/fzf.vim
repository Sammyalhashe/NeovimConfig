let $FZF_DEFAULT_COMMAND = 'ag --noaffinity -g ""'
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

function! BDEFiles() abort
    let l:OLD_FZF_DEFAULT_COMMANDA=$FZF_DEFAULT_COMMAND
    let $FZF_DEFAULT_COMMAND="find ~/Desktop/bde | ag"
    exec ':Files<CR>'
    let $FZF_DEFAULT_COMMAND=l:OLD_FZF_DEFAULT_COMMANDA
endfunction

function! GitWorkTreeFZF() abort
    call fzf#run(fzf#wrap({'source': "git worktree list | awk '{print $1}'", 'sink': 'cd'}))
    " TODO: find a way to update the current files with the file in the
    " worktree
    " TODO: find a way to configure hooks for certain repos.
endfunction

command! -bang GWT call GitWorkTreeFZF()

" ag --nogroup --column --color  -- '^(?=.)'
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--nogroup --noaffinity --color --column', fzf#vim#with_preview(), <bang>0)

" for vimgrep
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m


nnoremap <leader>e :GFiles<CR>
nnoremap <leader>d :Files ~/Desktop/bde<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>li :Lines<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>? :Rg<CR>
nnoremap <leader>w :GWT<CR>

if has('nvim')
	" let g:fzf_layout = {'window' : 'call FloatingFZF()'}
endif


function! s:build_quickfix_list(lines)
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
let $BAT_THEME = 'Solarized (dark)'
