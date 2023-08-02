local utils = require("utils")

local cmd = vim.cmd
local fn = vim.fn

--> Module level variables
local projectNotesDir = "~/what-ive-learned/notes"
local current_project = nil
local default_notes_ext = "norg"


local M = {}
M.override_selector = nil

function M.setup(opts)
    if opts.projectNotesDir then
        projectNotesDir = opts.projectNotesDir
    end

    if opts.mappings then
        local mappings = opts.mappings
        for k, v in pairs(mappings) do
            if k == "newNote" then
                vim.keymap.set('n', v, M.newNote)
            elseif k == "openNote" then
                vim.keymap.set('n', v, M.openNote)
            end
        end
    end

    if opts.default_notes_ext then
        default_notes_ext = opts.default_notes_ext
    end

    if opts.override_selector then
        M.override_selector = opts.override_selector
    end
end

--> local functions that depend on the setup state
local function buildProjectPrompt(projects)
    local prompt = ""
    for i, session in pairs(projects) do
        prompt = prompt .. "&" .. i .. " " .. session .. "\n"
    end
    return prompt
end

local function openProject(projectName)

end

function M.openNoteFile(note, opts)
    if opts and opts.create then
        local project_dir = projectNotesDir .. "/" .. current_project
        local note_split = utils.split_string(note, "/")
        local note_name = note_split[#note_split]
        local created = utils.createFile(project_dir, note_name)
        if not created then
            return
        end
    end

    cmd("topleft split " .. note)
end

function M.chooseNote(opts)
    M.setProject(current_project)

    local project_dir = projectNotesDir .. "/" .. current_project

    if opts and opts.newNote then
        local note_name = fn.input("Enter the name of the note: ")

        local prompt = "&y\n&n\n"
        local res = fn.confirm("Confirm choice: " .. project_dir .. "/" .. note_name .. "." .. default_notes_ext .. "?", prompt)

        if (res > 1) then
            return
        end

        M.openNoteFile(project_dir .. "/" .. note_name .. "." .. default_notes_ext, {create = true})
    else
        local notes = utils.getAllFilesInDir(project_dir .. "/", false)

        if M.override_selector then
            M.override_selector.chooseNote(notes)
            return
        end

        local prompt = buildProjectPrompt(notes)

        local res = fn.confirm("Select a note: ", prompt)

        local note = notes[res]
        M.openNoteFile(note, {create = false})
    end
end

function M.setProject(project, opts)
    if project == nil then
        local projects = utils.getAllFilesInDir(projectNotesDir, true)
        projects[#projects+1] = "new"
        local prompt = buildProjectPrompt(projects)

        local res = fn.confirm("Select a project: ", prompt)


        local project_name = projects[res]

        if project_name == "new" then
            project_name = fn.input("Enter the name of the project ")
            prompt = "&y\n&n\n"
            res = fn.confirm("Confirm choice: " .. project_name .. "?", prompt)

            if res > 1 then
                return
            end
            utils.mkdir(projectNotesDir .. "/" .. project_name, "p")
            project = project_name
        else
            project = project_name
        end
    end

    current_project = project

    if opts and opts.createDir then
        utils.mkdir(projectNotesDir .. "/" .. current_project, "p")
    end
end

function M.newNote()
    M.chooseNote({
        newNote = true,
    })
end

function M.openNote()
    M.chooseNote({
        newNote = false,
    })
end

return M
