local status, lspsaga = pcall(require, "lspsaga")
if (not status) then return end

local utils = require "utils"

lspsaga.setup {
    border_style = "rounded",
    -- Action keys should be:
    -- o/<cr>: open in current
    -- <c-x>: open in split
    -- <c-v>: open in vsplit
    -- They seem more complicated than the defaults but it's for consistency.
    keys = {
        split = "<c-x>",
        vsplit = "<c-v>",
        open = "<cr>",
    }
}

-- mappings
utils.map_allbuf("n", "K", "<cmd>Lspsaga hover_doc<CR>")
utils.map_allbuf("n", "gd", "<cmd>Lspsaga lsp_finder<CR>")
utils.map_allbuf("n", "<leader>ac", "<cmd>Lspsaga code_action<CR>")
utils.map_allbuf("n", "<leader>ee", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
utils.map_allbuf("n", "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>")
utils.map_allbuf("n", "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- utils.map_allbuf("n", "<leader>ar", "<cmd>Lspsaga rename<CR>")
