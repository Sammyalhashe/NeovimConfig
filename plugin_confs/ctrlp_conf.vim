" sets as the nearest ancestor that contains a version control marker
let g:ctrlp_working_path_mode = 'ra'

" cache
let g:ctrlp_cache_dir = $HOME . "/.cache/ctrlp"

" ctrlp command to use
if executable("ag")
	let g:ctrlp_user_command = "ag %s -l -g ''"
endif

" ignore irrelevant folders for better searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
