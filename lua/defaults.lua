--> aliases for config
local api    = vim.api
local g      = vim.g
local keymap = vim.keymap
local set    = vim.opt
local utils  = require "utils"
local wo     = vim.wo

--> searching in buffer
set.ignorecase = true
set.smartcase = true

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

--> easy mapping for executing shell commands
keymap.set("n", "!", ":!")

--> spell check
vim.spelllang = "en,cjk"
utils.map_allbuf("n", "<c-s>", ":set spell!<cr>")

--> clipboard
set.clipboard:append("unnamedplus")

--> prevent --INSERT-- from showing which conflicts with statuslines
set.showmode = false

--> colourcolumn (English/Canadian spelling only)
wo.colorcolumn = "80"

--> scrolloffset to 7 lines when when scrolling I can see more things.
set.so = 7

--> line numbers
wo.number         = true
wo.relativenumber = true

--> spaces/tabs
set.expandtab  = true
set.smarttab   = true
set.tabstop    = 4
set.shiftwidth = 4

--> split navigation
keymap.set("n", "<c-l>", "<c-w>l")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<c-h>", "<c-w>h")

--> nowrap
set.wrap = false

--> more characters will be sent to teh screen for redrawing
set.ttyfast = true

--> new splits will be at bottom/right of screen
set.splitbelow = true
set.splitright = true

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

api.nvim_create_user_command("TT", "tabnew | term", {})
api.nvim_create_user_command("VT", "vsplit | term", {})
api.nvim_create_user_command("ST", "split | term", {})

--> :noh convinience map
keymap.set("n", "<leader><cr>", "<cmd>noh<cr>")

--> open in same position when re-opening a file.
vim.cmd [[
" Return to last edit position when opening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]

--> Go to tabs by number
keymap.set("n", "<leader>1", "1gt")
keymap.set("n", "<leader>2", "2gt")
keymap.set("n", "<leader>3", "3gt")
keymap.set("n", "<leader>4", "4gt")
keymap.set("n", "<leader>5", "5gt")
keymap.set("n", "<leader>6", "6gt")
