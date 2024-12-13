local execute = vim.api.nvim_command
local fn = vim.fn

vim.g.minimal = false

local utils = require("utils")

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone --depth 1 https://github.com/wbthomason/packer.nvim "
        .. install_path)
    execute("packadd packer.nvim")
end

vim.cmd("packadd packer.nvim")

local packer = require("packer")
local util = require("packer.util")

packer.init({
    package_root = util.join_paths(fn.stdpath("data"), "site", "pack")
})

local main_plugins = {
    --> used by most plugins
    "nvim-lua/plenary.nvim",

    --> tmux integration
    "christoomey/vim-tmux-navigator",

    --> auto-close brackets
    "windwp/nvim-autopairs",

    --> teriminal stuff
    "akinsho/toggleterm.nvim",

    --> aesthetics
    "nvim-lualine/lualine.nvim",

    --> git gud
    "tpope/vim-fugitive",
    "pwntester/octo.nvim",

    --> treesitter
    { "nvim-treesitter/nvim-treesitter",          run = ":TSUpdate" },

    --> project navigation
    "nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "ThePrimeagen/harpoon",

    --> colorscheme
    "EdenEast/nightfox.nvim",
    "polirritmico/monokai-nightasty.nvim",
    "Mofiqul/adwaita.nvim",

    --> lsp
    {
        "williamboman/mason.nvim",
    },
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    {
        "nvimdev/lspsaga.nvim",
        after = "nvim-lspconfig",
    },

    --> organization/writing
    "nvim-orgmode/orgmode",
    "akinsho/org-bullets.nvim",
    {
        "chipsenkbeil/org-roam.nvim",
        dependencies = {
            {
                "nvim-orgmode/orgmode",
            },
        },
    },
    { 'michaelb/sniprun', run = 'sh ./install.sh'},
    "nvim-orgmode/telescope-orgmode.nvim",

    --> C++ Formatting
    "MovEaxEsp/bdeformat"
}

local bloated_plugins = {
    --> my plugins
    "Sammyalhashe/session_manager.nvim",

    --> aesthetics
    "kyazdani42/nvim-web-devicons",
    { "shortcuts/no-neck-pain.nvim", tag = "*"},

    --> git gud
    { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" },
    "tpope/vim-rhubarb",
    "lewis6991/gitsigns.nvim",

    --> project navigation
    "kyazdani42/nvim-tree.lua",
    "ThePrimeagen/git-worktree.nvim",

    --> colorscheme
    {
        "mcchrish/zenbones.nvim",
        -- Optionally install Lush. Allows for more configuration or extending the colorscheme
        -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
        -- In Vim, compat mode is turned on as Lush only works in Neovim.
        requires = "rktjmp/lush.nvim",
    },


    --> lsp
    "hrsh7th/cmp-emoji",

    --> dap
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
    {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" }
    },

    --> organization/writing
    "Pocco81/true-zen.nvim",
    "lukas-reineke/headlines.nvim",
    "dhruvasagar/vim-table-mode",

}

local plugins = { main_plugins }

if not vim.g.minimal then
    table.insert(plugins, bloated_plugins)
end

packer.startup(function()
    for _, plugins_table in ipairs(plugins) do
        for _, plugin in ipairs(plugins_table) do
            pcall(use, plugin)
        end
    end
end)
