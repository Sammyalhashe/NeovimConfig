" NOTE: from Abid's (trainer) config
" Explicitly set the python linters and fixers
let b:ale_linters = {'python': ['pylint']}
let g:ale_fixers = {'python': ['black']}


let g:ale_lint_on_text_changed = 'never'

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '•'

" ALE completion
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
