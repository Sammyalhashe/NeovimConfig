require'nvim-treesitter.configs'.setup{
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        custom_captures = {
            ["@todo"] = "Identifier",
        },
    },
    incremental_selection = {
        enable = true,
        init_selection = "gnn"
    },
    rainbow = {
        enable = true,
        extended_node = true,
    },
    move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@call.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@call.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@call.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@call.outer",
       },
    },
}
