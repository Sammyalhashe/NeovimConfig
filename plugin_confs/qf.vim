" Quickfix pane commands
" Go up and down the quickfix list and wrap around.
nmap <Home> <Plug>(qf_qf_previous)
nmap <End>  <Plug>(qf_qf_next)
" Jump to and from quickfix window
nmap + <Plug>(qf_qf_switch)
" Toggle the quickfix window
nmap <F4> <Plug>(qf_qf_toggle)
nmap <F5> <Plug>(qf_qf_toggle_stay)
" Enable these mappings:
" s - open entry in a new horizontal window
" v - open entry in a new vertical window
" t - open entry in a new tab
" o - open entry and come back
" O - open entry and close the location/quickfix window
" p - open entry in a preview window
let g:qf_mapping_ack_style = 1
