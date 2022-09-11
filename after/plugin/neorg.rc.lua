local status, neorg = pcall(require, "neorg")
if (not status) then return end

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
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
                workspace = "personal"
            },
        },
        ["core.export"] = {},
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode"
            },
        },
    }
}
