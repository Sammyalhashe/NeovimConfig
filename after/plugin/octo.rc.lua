local status, octo = pcall(require, "octo")
if not status then return end

octo.setup {
    default_remote = { "upstream", "origin" }, -- order to try remotes
}
