local runner = require("runner")

runner.setup {
    build_directions = {
        [vim.fn.expand("/bb/mom/alhasher/dmp-1")] = {
            "make",
            "cd cmake.bld/Linux/full",
            "make -j16"
        },
        [vim.fn.expand("~/Documents/budgeting")] = {
            "make"
        }
    }
}

vim.keymap.set("n", "<leader>/", function()
    runner.run(vim.fn.expand("%:p"), vim.bo.filetype)
end)
