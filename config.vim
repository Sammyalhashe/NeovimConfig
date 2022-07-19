" vim: foldmethod=marker

" source defaults
call Sourcer#SourcePluginConfs('defaults.vim')

" source surrounder
call Sourcer#SourcePluginConfs('surrounder.vim')

" source text_move
call Sourcer#SourcePluginConfs('text_move.vim')

" bde-format
call Sourcer#SourcePluginConfIfHavePlugin('bdeformat', 'bde_config.vim')

" fzf
call Sourcer#SourcePluginConfIfHavePlugin("telescope", "telescope.vim")

" lsp
call Sourcer#SourcePluginConfs('lsp.vim')
call Sourcer#SourcePluginConfIfHavePlugin("nvim-cmp", "nvim_cmp.vim")

" treesitter
call Sourcer#SourcePluginConfIfHavePlugin("nvim-treesitter", "treesitter.vim")
call Sourcer#SourcePluginConfIfHavePlugin("nvim-treesitter", "folding.vim")

" my statusline
call Sourcer#SourcePluginConfIfHavePlugin('lightline.vim', 'lightline_conf.vim')

" vim-qf
call Sourcer#SourcePluginConfIfHavePlugin("vim-qf", "qf.vim")

" cppman
call Sourcer#SourcePluginConfs('cppman.vim')

" tab management
call Sourcer#SourcePluginConfs('tabManagement.vim')

" org
call Sourcer#SourcePluginConfIfHavePlugin("orgmode", "orgmode_config.vim")
