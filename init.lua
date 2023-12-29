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
local home = vim.fn.stdpath("config")
local exists = utils.file_exists(home .. "/lua/local.lua")
if not exists then
    print(vim.cmd.pwd())
    if not utils.createFile(home .. "lua", "local.lua") then
        error("unable to create lua/local.lua")
        return
    end

    if not utils.file_exists(home .. "/lua/local_base.lua") then
        error("please create lua/local_base.lua")
        return
    end

    local data = utils.readFileSync(home .. "/lua/local_base.lua")

    local offset = utils.writeFileSync(home .. "/lua/local.lua", data)

    if utils.file_exists(home .. "/lua/local_color.lua") then
        utils.writeFileSync(home .. "/lua/local.lua", utils.readFileSync(home .. "/lua/local_color.lua"), offset)
    end
end

pcall(require, "local")

-- if running in neovide
if vim.g.neovide then
    require "neovide"
end

vim.g.wsl = vim.fn.has("wsl")

-- other defaults and my own code
require "defaults"
require "plugins"
require "runner"
require "split"
require "help_terminal"
