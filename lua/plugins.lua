local execute = vim.api.nvim_command
local fn = vim.fn

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

packer.startup(function()
    --> used by most plugins
    use "nvim-lua/plenary.nvim"

    --> my plugins
    use "Sammyalhashe/session_manager.nvim"

    --> Misc
    use "folke/which-key.nvim"

    --> tmux integration
    use "christoomey/vim-tmux-navigator"

    --> auto-close brackets
    use "windwp/nvim-autopairs"

    --> comments plugin
    use "terrortylor/nvim-comment"

    --> aesthetics
    use "kyazdani42/nvim-web-devicons"
    use "nvim-lualine/lualine.nvim"
    use "folke/todo-comments.nvim"
    use "rcarriga/nvim-notify"

    --> git gud
    use "tpope/vim-fugitive"
    use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }
    use "lewis6991/gitsigns.nvim"
    use "pwntester/octo.nvim"

    --> treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    --> project navigation
    use "kyazdani42/nvim-tree.lua"
    use "nvim-telescope/telescope.nvim"
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use "nvim-telescope/telescope-file-browser.nvim"
    use "ThePrimeagen/git-worktree.nvim"
    use "folke/trouble.nvim"

    --> colorscheme
    use {
        "luisiacc/gruvbox-baby",
        branch = "main"
    }
    use ({ 'projekt0n/github-nvim-theme', tag = 'v0.0.7' })
    use "EdenEast/nightfox.nvim"
    use "polirritmico/monokai-nightasty.nvim"

    --> lsp
    use {
        "williamboman/mason.nvim"
    }
    use "neovim/nvim-lspconfig"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-emoji"
    use "ray-x/lsp_signature.nvim"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use {
        "nvimdev/lspsaga.nvim",
        after = "nvim-lspconfig"
    }

    --> organization/writing
    --> Hopefully I can fully switch to neorg once it matures, but until then,
    --I think orgmode has its place.
    use { "nvim-neorg/neorg", requires = { "nvim-neorg/neorg-telescope" } }
    use "Pocco81//true-zen.nvim"
    -- use "nvim-orgmode/orgmode"
    -- use "ainsho/org-bullets.nvim"
    use "dhruvasagar/vim-table-mode"

    --> C++ Formatting
    use "MovEaxEsp/bdeformat"
end)
