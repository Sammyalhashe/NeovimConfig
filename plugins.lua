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
    --> colorscheme
    use {
        "luisiacc/gruvbox-baby",
        branch = "main",
        config = function ()
            vim.cmd("colorscheme gruvbox-baby")
        end
    }

    --> lsp
    use "neovim/nvim-lspconfig"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "mhartington/formatter.nvim"
    use "ray-x/lsp_signature.nvim"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
end)
