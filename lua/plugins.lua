local utils = require("utils")

-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        -- Uncomment next line to use 'stable' branch
        -- '--branch', 'stable',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
end

require("mini.deps").setup({ path = { package = path_package } })
local add = MiniDeps.add

local main_plugins = {
    --> used by most plugins
    { source = "nvim-lua/plenary.nvim" },

    --> tmux integration
    { source = "christoomey/vim-tmux-navigator" },

    --> auto-close brackets
    { source = "windwp/nvim-autopairs" },

    --> teriminal stuff
    { source = "akinsho/toggleterm.nvim" },

    --> aesthetics
    { source = "nvim-lualine/lualine.nvim" },

    --> git gud
    { source = "tpope/vim-fugitive" },
    { source = "pwntester/octo.nvim" },

    --> treesitter
    { source = "nvim-treesitter/nvim-treesitter", hooks = { post_checkout = function() vim.cmd("TSUpdate") end } },

    --> project navigation
    { source = "nvim-telescope/telescope.nvim" },
    {
        source = "nvim-telescope/telescope-fzf-native.nvim",
        hooks = {
            post_install = function()
                print("running make!")
                vim.fn.system("make")
                print("after make!")
            end
        }
    },
    { source = "nvim-telescope/telescope-file-browser.nvim" },
    { source = "ThePrimeagen/harpoon" },

    --> colorscheme
    { source = "EdenEast/nightfox.nvim" },
    { source = "polirritmico/monokai-nightasty.nvim" },
    { source = "Mofiqul/adwaita.nvim" },

    --> lsp
    { source = "williamboman/mason.nvim" },
    { source = "neovim/nvim-lspconfig" },
    { source = "hrsh7th/cmp-nvim-lsp" },
    { source = "hrsh7th/nvim-cmp" },
    { source = "hrsh7th/cmp-buffer" },
    { source = "hrsh7th/cmp-nvim-lsp-signature-help" },
    { source = "L3MON4D3/LuaSnip" },
    { source = "saadparwaiz1/cmp_luasnip" },
    { source = "nvimdev/lspsaga.nvim",                      depends = { "nvim-lspconfig" } },

    --> organization/writing
    { source = "nvim-orgmode/orgmode" },
    { source = "akinsho/org-bullets.nvim" },
    { source = "chipsenkbeil/org-roam.nvim",                depends = { "nvim-orgmode/orgmode" } },
    {
        source = 'michaelb/sniprun',
        hooks = {
            post_install = function()
                vim.fn.system(
                    'sh ./install.sh')
            end
        }
    },
    { source = "nvim-orgmode/telescope-orgmode.nvim" },

    --> C++ Formatting
    { source = "MovEaxEsp/bdeformat" }
}

local my_plugins = {
    { source = "Sammyalhashe/session_manager.nvim" }
}

local bloated_plugins = {
    --> aesthetics
    { "shortcuts/no-neck-pain.nvim", tag = "*" },

    --> organization/writing
    "Pocco81/true-zen.nvim",
    "lukas-reineke/headlines.nvim",
    "dhruvasagar/vim-table-mode",
}

local plugins = { main_plugins, my_plugins }

if not utils.valueOrDefault(vim.g.minimal, false) then
    table.insert(plugins, bloated_plugins)
end

for _, plugins_table in ipairs(plugins) do
    for _, plugin in ipairs(plugins_table) do
        pcall(add, plugin)
    end
end
