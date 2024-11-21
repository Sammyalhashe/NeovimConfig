local status, roam = pcall(require, "org-roam")
if not status then return end

local utils = require("utils")

roam.setup(utils.valueOrDefault(vim.g.roam_config, { directory = "~/Roam" }))
