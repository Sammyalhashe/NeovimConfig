--> enable termdebug
vim.cmd("packadd termdebug")

vim.g.termdebug_config = {}

vim.keymap.set("n", ",n", function ()
    vim.cmd("Over")
end)


vim.keymap.set("n", ",s", function ()
    vim.cmd("Step")
end)


vim.keymap.set("n", ",b", function ()
    vim.cmd("Break")
end)

vim.keymap.set({"v", "n"}, ",e", function ()
    vim.cmd("Evaluate")
end)



