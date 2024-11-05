local status, roam = pcall(require, "org-roam")
if not status then return end

roam.setup({
    directory = "~/Roam"
})
