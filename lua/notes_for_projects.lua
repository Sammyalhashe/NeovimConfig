local utils = require("utils")

local cmd = vim.cmd
local fn = vim.fn

--> Module level variables
local projectNotesDir = nil
local defaultProject = nil
local current_project = nil
local default_notes_ext = "md"

local previous_dir = nil


local M = {}
M.override_selector = nil

function M.setup(opts)
    if not opts.default_notes_dir then
        print("please provide `default_notes_dir` to use notes_for_project...")
        return
    end

    projectNotesDir = opts.default_notes_dir

    if opts.projectNotesDir then
        projectNotesDir = opts.projectNotesDir
    end

    if opts.default_notes_project then
        current_project = opts.default_notes_project
        defaultProject = opts.default_notes_project
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

function M.openNoteFile(note, opts)
    if not projectNotesDir then
        print("set `default_notes_dir` in your setup function")
        return
    end

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

    -- previous_dir = vim.fn.getcwd()
    cmd("lcd " .. projectNotesDir)

    vim.api.nvim_create_autocmd(
        {"BufLeave"},
        {
            callback = function()
                if previous_dir then
                    -- cmd("cd " .. previous_dir)
                    -- previous_dir = nil
                end
            end,
            buffer = vim.fn.bufnr()
        }
    )

    vim.api.nvim_create_autocmd(
        {"BufEnter"},
        {
            callback = function()
                -- previous_dir = vim.fn.getcwd()
                -- cmd("cd " .. projectNotesDir)
                cmd("lcd " .. projectNotesDir)
            end,
            buffer = vim.fn.bufnr()
        }
    )
end

function M.chooseNote(opts)
    if not projectNotesDir then
        print("set `default_notes_dir` in your setup function")
        return
    end

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
    if not projectNotesDir then
        print("set `default_notes_dir` in your setup function")
        return
    end

    local projects = utils.getAllFilesInDir(projectNotesDir, true)

    if project ~= nil and (opts and not opts.createDir) and not utils.entryInTable(project, projects) then
        print("project " .. project .. " does not exist. Aborting...")
        return
    end

    if project == nil then
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
            utils.mkdir(projectNotesDir .. "/" .. project_name, "p", 493)
            project = project_name
        else
            project = project_name
        end
    end

    current_project = project

    if opts and opts.createDir then
        utils.mkdir(projectNotesDir .. "/" .. current_project, "p", 493)
    end
end

function M.newNote()
    if not projectNotesDir then
        print("set `default_notes_dir` in your setup function")
        return
    end

    M.chooseNote({
        newNote = true,
    })
end

function M.openNote()
    if not projectNotesDir then
        print("set `default_notes_dir` in your setup function")
        return
    end

    M.chooseNote({
        newNote = false,
    })
end

vim.api.nvim_create_user_command("NoteDef", function(opts)
    if defaultProject then
        M.setProject(defaultProject)
    end
end, {
    bang = true
})

vim.api.nvim_create_user_command("NoteSetProject", function(opts)
    if opts.args then
        local projectToChoose = opts.args
        M.setProject(projectToChoose)
        return
    end
    M.setProject(nil, { createDir = false })
end,
{
    bang = true,
    nargs = 1
})

vim.api.nvim_create_user_command("NoteCreateProject", function(opts)
    if not opts.args or not #opts.args then
        print("Please provide a name of the project...")
        return
    end

    local project = opts.args
    M.setProject(project, { createDir = true })
end,
{
    bang = true,
    nargs = 1
})

return M
