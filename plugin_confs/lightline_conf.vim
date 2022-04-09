set laststatus=2

if has("nvim-0.6")
    let s:ERROR="ERROR"
    let s:WARN="WARN"
else
    let s:ERROR="[[Error]]"
    let s:WARN="[[Warning]]"
end

if has('gui_running')
		set t_Co=256
endif

set noshowmode " unecessary with this plugin

function! LspDiagnostics(level) abort
    let diagnotic_command = has("nvim-0.6") ? 'vim.diagnostic.get' : 'vim.lsp.diagnostic.get_count'
    if has("nvim-0.6")
        let l:result = luaeval('vim.diagnostic.get(' . bufnr() . ', { severity = vim.diagnostic.severity.' . a:level . '})')
        return len(l:result)
    else
        return luaeval('vim.lsp.diagnostic.get_count(' . bufnr() . ',' . a:level . ')')
    end
endfunction

function! DisplayLspDiagnostics()
    let eCount = LspDiagnostics(s:ERROR)
    let wCount = LspDiagnostics(s:WARN)
    return printf("E: %d W: %d", eCount, wCount)
endfunction

if len(g:ITERM2_PRESET) != 0
    let colorscheme = g:ITERM2_PRESET
else
    let colorscheme = "onehalflight"
endif

let g:lightline = {
			\ 'colorscheme': (colorscheme == "onehalflight" || colorscheme == "onehalfdark") ? "one" : colorscheme,
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
