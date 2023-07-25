local utils = require("utils")

--> Determine the os
function GetOs()

    -- Unix, Linux varients
    local fh, _ = io.popen("uname -a 2>/dev/null", "r")
    if not fh then return "unknown" end
    local osname = nil
    if fh then
        osname = fh:read()
    end
    if osname then return osname end

    -- Add code for other operating systems here
    return "unknown"
end

vim.g.os = utils.split_string(GetOs(), " ")[1]

--> Determine if in work env
--> This will load if there and not do anything if not
pcall(require, "bb")

-- if running in neovide
if vim.g.neovide then
    require "neovide"
end

-- setting the clipboard for wsl
vim.g.wsl = vim.fn.has("wsl")
if vim.fn.has("wsl") then
    -- vim.cmd([[
    --     let g:clipboard = {
    --                 \   'name': 'WslClipboard',
    --                 \   'copy': {
    --                 \      '+': 'clip.exe',
    --                 \      '*': 'clip.exe',
    --                 \    },
    --                 \   'paste': {
    --                 \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --                 \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --                 \   },
    --                 \   'cache_enabled': 0,
    --                 \ }
    -- ]])
end

-- other defaults and my own code
require "plugins"
require "defaults"
require "runner"
