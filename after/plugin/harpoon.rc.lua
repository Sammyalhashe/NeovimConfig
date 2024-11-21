local status, harpoon = pcall(require, "harpoon")
if not status then return end

local utils = require("utils")

harpoon.setup({})


--> keymaps
--> add file to harpoon list
utils.map_allbuf("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>")
--> toggle harpoon menu
utils.map_allbuf("n", "<leader>ht", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
--> previous/next harpoon toggle
utils.map_allbuf("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()<CR>")
utils.map_allbuf("n", "<leader>hn", ":lua require('harpoon.ui').nav_next()<CR>")

--> cmd-ui
utils.map_allbuf("n", "<leader>hc", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>")

