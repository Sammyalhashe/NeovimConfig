local status, nvim_tree = pcall(require, "nvim-tree")
if (not status) then return end

local utils = require("utils")

nvim_tree.setup {
    filters = {
        --> show dotfiles
        dotfiles = true,
    },
}

--> create easy commands to run
local opts = {}
vim.api.nvim_create_user_command("NT", "NvimTreeToggle", opts)

--> mappings also
utils.map_allbuf("n", "<leader>t", "<cmd>NvimTreeToggle<cr>")
