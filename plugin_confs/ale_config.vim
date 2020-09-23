" NOTE: from Abid's (trainer) config
" Explicitly set the python linters and fixers


call ale#linter#Define('python', {
			\   'name': 'pyls',
			\   'lsp': 'socket',
			\   'address_callback': {-> '127.0.0.1:10777'},
			\   'address': {-> '127.0.0.1:10777'},
			\   'language': 'python',
			\   'project_root': 'ale#python#FindProjectRoot',
			\   'completion_filter': 'ale#completion#python#CompletionItemFilter',
			\})

let b:ale_linters = {'python': ['pyls', 'pylint']}
let g:ale_fixers = {'python': ['black']}
let g:ale_virtualenv_dir_names = ['venv', '.venv']

let g:ale_lint_on_text_changed = 'never'

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '•'

" Replaced by coc
" ALE completion
" let g:ale_completion_enabled = 1
" let g:ale_completion_autoimport = 1
" set omnifunc=ale#completion#OmniFunc

" nnoremap <silent> <leader>gd :ALEGoToDefinition<CR>
" nnoremap <silent> <leader>gr :ALEFindReferences<CR>

" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
