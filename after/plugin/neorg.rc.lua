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
        ["core.keybinds"] = {
            config = {
                hook = function(keybinds)
                    keybinds.remap_key("norg", "n", "<C-Space>", "<Leader>tn")
                end,
            }
        },
        ["core.concealer"] = {},
        ["core.looking-glass"] = {},
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
        ["core.export"] = {config = {extensions = "all"}},
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

--> keybinds
vim.keymap.set("n", "<leader>o'", ":Neorg keybind all core.looking-glass.magnify-code-block<cr>", {silent=true})


vim.api.nvim_create_user_command("EX", function()
    require('neorg_utils').convertNorgFilesAndPlaceInDirectory('~/Desktop/DesktopHolder/what-ive-learned/',
        '~/Desktop/test', true)
end, {})
