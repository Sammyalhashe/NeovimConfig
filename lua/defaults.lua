--> aliases for config
local api    = vim.api
local g      = vim.g
local keymap = vim.keymap
local set    = vim.opt
local wo     = vim.wo

--> encoding
set.encoding       = "utf-8"
vim.scriptencoding = "utf-8"

--> I don't use backups
set.backup      = false
set.writebackup = false
set.swapfile    = false

--> mapleaders
g.mapleader      = " "
g.maplocalleader = " "

--> spell check
vim.spelllang = en, cjk

--> prevent --INSERT-- from showing which conflicts with statuslines
vim.noshowmode = true

--> colourcolumn (English/Canadian spelling only)
wo.colorcolumn = "80"

--> line numbers
wo.number         = true
wo.relativenumber = true

--> spaces/tabs
set.expandtab  = true
set.smarttab   = true
set.tabstop    = 4
set.shiftwidth = 4

--> nowrap
set.wrap = false

--> terminal mode TODO Maybe move this to own config file.
keymap.set("t", "<esc>", "<c-\\><c-n>")
-- I don't want the terminal to have numbers
local openterminalaugroup = api.nvim_create_augroup(
    "terminal_cmds",
    { clear = true }
)
api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    group   = openterminalaugroup,
    command = "setlocal nonumber"
})
