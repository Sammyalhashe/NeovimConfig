set laststatus=2

if has('gui_running')
		set t_Co=256
endif

set noshowmode " unecessary with this plugin

function! LspDiagnostics(level) abort
    let l:result = luaeval('vim.diagnostic.get(' . bufnr() . ', { severity = vim.diagnostic.severity.' . a:level . '})')
    return len(l:result)
endfunction

function! DisplayLspDiagnostics()
    let eCount = LspDiagnostics('ERROR')
    let wCount = LspDiagnostics('WARN')
    return printf("E: %d W: %d", eCount, wCount)
endfunction

let g:lightline = {
			\ 'colorscheme': 'nord',
			\ 'active': {
			\ 	'left': [['mode', 'paste'],
            \           ['gitbranch',
            \            'filename',
            \            'lsp_diagnostics',
            \            'modified',
            \           ]]
			\ },
			\ 'component': {
			\ 	'charvaluehex': '0x%B',
			\ 	'sammy': 'Hello Sammmy'
			\ },
            \ 'component_function': {
            \   'gitbranch': 'FugitiveHead',
            \   'lsp_diagnostics': 'DisplayLspDiagnostics'
            \ },
            \ 'component_expand': {
            \}
			\ }
