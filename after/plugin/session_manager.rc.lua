local status, session_manager = pcall(require, "session_manager")
if not status then return end

local utils = require("utils")

session_manager.setup {
    mappings = {
        chooseSession = "\\cs",
        saveSession = "\\ss",
        deleteSession = "\\ds"
    }
}
