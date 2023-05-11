local status, true_zen = pcall(require, "true-zen")
if not status then return end

true_zen.setup {
    integrations = {
        lualine = false, -- NOTE: hides lualine.
        tmux = false     -- NOTE: hides tmux status bar.
    }
}
