local status, neorg = pcall(require, "neorg")
if (not status) then return end

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work_dev = "~/neorg",
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
                workspace = "work_dev"
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
                workspace = "~/neorg",
                strategy = "nested",
            }
        }
    }
}
