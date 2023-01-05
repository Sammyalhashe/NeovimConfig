local status, trouble = pcall(require, "trouble")
if (not status) then return end

local utils = require "utils"

-- configguration
trouble.setup {
    position = "top",
    icons = true,
}


-- mappings
utils.map_allbuf("n", "<leader>xx", "<cmd>TroubleToggle<CR>")
utils.map_allbuf("n", "<leader>xd", "<cmd>TroubleToggle workspace_diagnostics<CR>")
utils.map_allbuf("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
