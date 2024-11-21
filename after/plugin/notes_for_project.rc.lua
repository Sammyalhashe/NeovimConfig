local status, notes_for_project = pcall(require, "notes_for_projects")
if not status then return end

local utils = require("utils")



notes_for_project.setup {
    mappings = {
        newNote = "\\q",
        openNote = "\\o"
    },
    default_notes_ext = "org",
    override_selector = require("notes_for_projects_telescope_ext"),
    default_notes_dir = utils.valueOrDefault(vim.g.default_notes_dir, "notes"),
    default_notes_project = utils.valueOrDefault(vim.g.default_notes_project, "~/my_test_project")
}
