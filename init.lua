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

require "plugins"
require "defaults"
