local status, neorg = pcall(require, "neorg")
if (not status) then return end

local utils = require 'utils'

local function loadGlobal(global, default)
    if global then
        return global
    end
    return default
end

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.neorgcmd"] = {},
        ["core.keybinds"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = loadGlobal(vim.g.workspaces, {})
            },
            default_workspace = "personal"
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.syntax"] = {},
        ["core.integrations.treesitter"] = {},
        -- ["core.gtd.base"] = {
        --     config = {
        --         workspace = "work"
        --     },
        -- },
        ["core.export"] = {},
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode"
            },
        },
        ["core.journal"] = {
            config = {
                journal_folder = utils.expandFilePath(loadGlobal(vim.g.neorg_journal_folder, "")),
                workspace = "journal",
                template_name = "template.norg",
                use_template = true,
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
    require('neorg_utils').convertNorgFilesAndPlaceInDirectory('~/Desktop/DesktopHolder/what-ive-learned/',
        '~/Desktop/test', true)
end, {})
