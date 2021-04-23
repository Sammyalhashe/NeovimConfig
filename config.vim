" vim: foldmethod=marker


" source defaults
call Sourcer#SourcePluginConfs('defaults.vim')

" source surrounder
call Sourcer#SourcePluginConfs('surrounder.vim')

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
call Sourcer#SourcePluginConfIfHavePlugin("nvim-treesitter", "folding.vim")

" my statusline
" call Sourcer#SourcePluginConfIfHavePlugin('nvim-web-devicons', 'statusline.vim')
call Sourcer#SourcePluginConfIfHavePlugin('galaxyline.nvim', 'galaxyline.vim')

" my tabline
" call Sourcer#SourcePluginConfs('tabline.vim')

" vim-qf
call Sourcer#SourcePluginConfIfHavePlugin("vim-qf", "qf.vim")

" close brackets
call Sourcer#SourcePluginConfs('close_brackets.vim')

" lspkind
call Sourcer#SourcePluginConfIfHavePlugin('lspkind-nvim', 'lspkind.vim')

" search_and_replace
call Sourcer#SourcePluginConfs('search_and_replace.vim')
