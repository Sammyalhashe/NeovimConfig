local utils = require "utils"
local wanted = utils.valueOrDefault(vim.g.color, "carbonfox")

vim.o.background = utils.valueOrDefault(vim.g.background, "dark")

if utils.string_contains(wanted, "fox$") then
    local status, nightfox = pcall(require, "nightfox")
    if (not status) then return end

    nightfox.setup {
        options = {
            styles = {
                comments = "italic",
                keywords = "bold",
                types = "italic,bold",
            },
            dim_inactive = true,
        },
        specs = {},
        groups = {
            all = {
                Search = { bg = "palette.red" },
            },
        },
    }

    colorscheme = wanted
elseif utils.string_contains(wanted, "baby$") then
    local status, _ = pcall(require, "gruvbox-baby")
    if (not status) then return end

    colorscheme = wanted

    vim.g.gruvbox_baby_telescope_theme = 1
elseif utils.string_contains(wanted, "bones$") then
    print("here")
    vim.g.zenbones_solid_line_nr = true
    vim.g.zenbones_darken_comments = 45
    vim.g.zenbones_italic_comments = true
    colorscheme = wanted
else
    colorscheme = wanted
end


vim.o.background = "light"
vim.cmd("colorscheme " .. colorscheme)
