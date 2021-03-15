require'nvim-treesitter.configs'.setup{
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        custom_captures = {
            ["@todo"] = "Identifier",
        },
    },
    incremental_selection = {
        enable = true
    },
}
