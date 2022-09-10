local status, lspsaga = pcall(require, "lspsaga")
if (not status) then return end

local utils = require"utils"

lspsaga.init_lsp_saga {
}

utils.map_allbuf("n", "K", "<cmd>Lspsaga hover_doc<CR>")
utils.map_allbuf("n", "gd", "<cmd>Lspsaga lsp_finder<CR>")
