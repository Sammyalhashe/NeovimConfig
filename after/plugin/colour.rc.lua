local utils = require "utils"
local colorscheme = "default"
local wanted = "github_dark"


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
else
    colorscheme = wanted
end

vim.cmd("colorscheme " .. colorscheme)
