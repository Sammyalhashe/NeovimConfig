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

" timer
call Sourcer#SourcePluginConfs('timer.vim')

" bde-format
call Sourcer#SourcePluginConfIfHavePlugin('bdeformat', 'bde_config.vim')

" fzf
call Sourcer#SourcePluginConfIfHavePlugin("fzf", "fzf.vim")

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

" close brackets
call Sourcer#SourcePluginConfs('close_brackets.vim')

" lspkind
call Sourcer#SourcePluginConfIfHavePlugin('lspkind-nvim', 'lspkind.vim')

" search_and_replace
call Sourcer#SourcePluginConfs('search_and_replace.vim')

" cppman
call Sourcer#SourcePluginConfs('cppman.vim')

" tab management
call Sourcer#SourcePluginConfs('tabManagement.vim')

" nvim-dashboard
call Sourcer#SourcePluginConfIfHavePlugin('dashboard-nvim', 'dashboard.vim')

" todo-comments
call Sourcer#SourcePluginConfIfHavePlugin("todo-comments.nvim", "todo-comments.vim")

" trouble
call Sourcer#SourcePluginConfIfHavePlugin("trouble.nvim", "trouble.vim")
