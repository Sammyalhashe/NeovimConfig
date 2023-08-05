local status, session_manager = pcall(require, "session_manager")
if not status then return end

session_manager.setup {
    mappings = {
        chooseSession = "\\cs",
        saveSession = "\\ss",
        deleteSession = "\\ds",
        newSession = "\\ns"
    },
    override_selector = require("session_manager.telescope_ext")
}
