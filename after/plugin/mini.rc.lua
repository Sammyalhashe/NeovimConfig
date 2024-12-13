local utils = require "utils"

--> mini.pick
require("mini.pick").setup({
    mappings = {
        move_down = '<C-j>',
        move_up = '<C-k>',
        scroll_down = '<C-d>',
        -- scroll_up = '<C-u>',
    },
    window = {
        prompt_prefix = " ",
    }
})
require("mini.extra").setup()

--> mini.files
require("mini.files").setup()


local setup_initializations = function()
    --> mini.pick
    local pick = "<cmd>Pick "
    local cr = "<cr>"

    -- Setup mappings (normal mode)
    utils.map_allbuf('n', '<leader>ff', pick .. "files" .. cr)
    utils.map_allbuf('n', '<leader>pf', pick .. " git_files" .. cr)
    utils.map_allbuf('n', '<leader>ag', pick .. " grep_live" .. cr)

    --> mini.files
    local minifiles = "<cmd>lua MiniFiles"
    utils.map_allbuf('n', '<leader>c', minifiles .. ".open()" .. cr)
end


setup_initializations()

