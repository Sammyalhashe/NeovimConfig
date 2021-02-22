" vim: foldmethod=marker


" source defaults
call Sourcer#SourcePluginConfs('defaults.vim')

" source text_move
call Sourcer#SourcePluginConfs('text_move.vim')

" session management
call Sourcer#SourcePluginConfs('session_management.vim')

" folding
call Sourcer#SourcePluginConfs('folding.vim')

" bde-format
call Sourcer#SourcePluginConfIfHavePlugin('bdeformat', 'bde_config.vim')

" fzf
call Sourcer#SourcePluginConfIfHavePlugin("fzf", "fzf.vim")

" lsp
call Sourcer#SourcePluginConfs('lsp.vim')

" treesitter
call Sourcer#SourcePluginConfIfHavePlugin("nvim-treesitter", "treesitter.vim")

" my statusline
call Sourcer#SourcePluginConfIfHavePlugin('vim-devicons', 'statusline.vim')

" my tabline
call Sourcer#SourcePluginConfs('tabline.vim')

" vim-qf
call Sourcer#SourcePluginConfIfHavePlugin("vim-qf", "qf.vim")

" close brackets
call Sourcer#SourcePluginConfs('close_brackets.vim')

" rhubarb
let g:github_enterprise_urls = ['https://bbgithub.dev.bloomberg.com']
