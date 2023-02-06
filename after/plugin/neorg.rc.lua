local status, neorg = pcall(require, "neorg")
if (not status) then return end

local utils = require 'utils'
local neorg_utils = require 'neorg_utils'

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.neorgcmd"] = {},
        ["core.keybinds"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work_dev = "~/neorg",
                    work = "~/Desktop/what-ive-learned",
                    personal = "~/Dropbox/Org/Orgzly",
                }
            }
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.syntax"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.gtd.base"] = {
            config = {
                workspace = "work"
            },
        },
        ["core.export"] = {},
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode"
            },
        },
        ["core.norg.journal"] = {
            config = {
                workspace = "work",
                strategy = "nested",
                toc_format = function(t)
                    return t
                end
            },
        },
        ["core.integrations.telescope"] = {},
    }
}


vim.api.nvim_create_user_command("EX", function()
    require('neorg_utils').convertNorgFilesAndPlaceInDirectory('~/Desktop/DesktopHolder/what-ive-learned/', '~/Desktop/test', true)
end, {})
