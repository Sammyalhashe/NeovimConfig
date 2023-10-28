local runner = require("runner")

runner.setup {
    build_directions = {
        [vim.fn.expand("/bb/mom/alhasher/dmp-1")] = {
            { cmd = "make" },
            { cmd = "make -j16", cwd = "|workdir|/cmake.bld/Linux/full" }
        },
        [vim.fn.expand("~/Documents/budgeting")] = {
            { cmd = "make" }
        },
        [vim.fn.expand("~/dmp-1")] = {
            { cmd = "make -j30", cwd = "|workdir|/cmake.bld/Linux/full", targets = { "it", "all" } }
        },
        [vim.fn.expand("~/crypto_trader")] = {
            { cmd = "make -j30", cwd = "|workdir|/cmake.bld/Linux/full" }
        }
    },
    prepare_directions = {
        [vim.fn.expand("~/crypto_trader")] = {
            { cmd = "make -j30" }
        }
    }
}

vim.keymap.set("n", "<leader>/", function()
    runner.run(vim.fn.expand("%:p"), vim.bo.filetype)
end)

vim.keymap.set("n", "<leader>//", function()
    runner.run(vim.fn.expand("%:p"), vim.bo.filetype, { prepare = true })
end)
