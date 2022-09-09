local status, treesitter = pcall(require, "nvim-treesitter")
if (not status) then return end

local wantedParsers = {
    "bash"; "javascript"; "cpp"; "c"; "python"; "lua"
};

require 'nvim-treesitter.configs'.setup {
    ensure_installed = wantedParsers,
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

local ft_str = table.concat(
    vim.tbl_map(
        function(ft)
            return require 'nvim-treesitter.configs'[ft] or ft
        end,
        require('nvim-treesitter.parsers').available_parsers()
    ),
    ","
)

-- NOTE: Uncomment this if you want folding.
-- vim.cmd("autocmd Filetype " .. ft_str .. ",cpp" .. " setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()")
