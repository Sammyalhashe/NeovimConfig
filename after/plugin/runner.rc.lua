local runner = require("runner")

local command= "<cmd>lua require'runner'.run(" .. vim.fn.expand("%:p") .. ", " .. vim.bo.filetype .. ")<CR>"
print(command)

vim.keymap.set("n", "<leader>/", function ()
    print("erer")
    runner.run(vim.fn.expand("%:p"), vim.bo.filetype)
end)
