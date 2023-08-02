local status, pickers = pcall(require, "telescope.pickers")
if not status then return nil end

local actions = require("telescope.actions")
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local finders = require("telescope.finders")

local notes_for_projects = require("notes_for_projects")

local function runWithTelescope(selections, cb, prompt)
    local entry_maker = function(entry)
        return {
            value = entry,
            display = entry,
            ordinal = entry,
        }
    end
    local opts = {}
    pickers.new(opts, {
        prompt_title = prompt,
        finder = finders.new_table {
            results = selections,
            entry_maker = entry_maker
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = cb
    }):find()
end

local M = {}

function M.chooseProject(projects)
    local action = function(prompt_bufnr, map)
        actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection.value == "new" then
                selection.value = nil
            end
            notes_for_projects.setProject(selection.value, {
                createDir = selection.value == nil
            })
        end)
        return true
    end
    projects[#projects+1] = "new"
    runWithTelescope(projects, action, "Choose project")
end


function M.chooseNote(notes)
    local action = function(prompt_bufnr, map)
        actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            notes_for_projects.openNoteFile(selection.value)
        end)
        return true
    end
    runWithTelescope(notes, action, "Choose project")
end

return M
