local status, _ = pcall(require, "gruvbox-baby")
if (not status) then return end

vim.cmd("colorscheme gruvbox-baby")

vim.g.gruvbox_baby_telescope_theme = 1
