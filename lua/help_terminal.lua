local telescope_status, telescope = pcall(require, "telescope")

local utils = require("utils")

-- alias fn/cmd
local fn = vim.fn


local M = {}


local most_recent_rel_dir = nil
local most_recent_cmd = nil
local most_recent_split = nil
local command_cache = {}

local save_cmd_cache = function(rel_dir, cmds)
    if command_cache[rel_dir] == nil then
        command_cache[rel_dir] = {}
    end
    local cmdArr = command_cache[rel_dir]

    -- don't add twice
    for _, value in ipairs(cmdArr) do
        if value == cmds then
            return
        end
    end
    cmdArr[#cmdArr + 1] = cmds
end


local open_scratch = function(rel_dir, cmds)
    local job_status, job = pcall(require, "plenary.job")
    if not job_status then return end

    local bufnr = utils.makeScratch("/tmp/scratch")
    utils.clearBufferContents(bufnr)
    local scratch_index = 0

    vim.schedule(function()
        local bufname = vim.fn.bufname(bufnr)
        vim.cmd("botright split " .. bufname)
    end)
    job:new({
        command = cmds,
        args = {},
        cwd = rel_dir,
        on_stdout = function(err, data)
            if not err then
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(bufnr, scratch_index, scratch_index, true, { data })
                    scratch_index = scratch_index + 1
                end)
            end
        end,
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                local result = j:result()
                if #result ~= 0 then
                    vim.schedule(function()
                        vim.api.nvim_buf_set_lines(bufnr, scratch_index, scratch_index, true, result)
                        scratch_index = scratch_index + 1
                    end)
                end
            end
            save_cmd_cache(rel_dir, cmds)
        end,
        on_stderr = function(err, data)
            vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, scratch_index, scratch_index, true, { data })
                scratch_index = scratch_index + 1
            end)
        end
    }):start()
end

-- returns -1 on failure
function GetXPercentWindowWidth(X)
    local window_width = vim.fn.winwidth(0) -- 0 means current window
    return math.floor((X / 100) * window_width)
end

-- returns -1 on failure
function GetYPercentWindowHeight(Y)
    local window_height = vim.fn.winheight(0) -- 0 means current window
    return math.floor((Y / 100) * window_height)
end

local open_terminal = function(rel_dir, cmds, opts)
    local split_command = (opts and opts["split_command"]) or "edit"
    if split_command == "rerun" then
        split_command = most_recent_split or "edit"
    elseif split_command == "edit" then
        split_command = "edit"
    elseif split_command == "split" then
        local split_cols = GetYPercentWindowHeight(20)
        split_command = split_cols .. split_command
    elseif split_command == "vsplit" then
        local split_rows = GetXPercentWindowWidth(30)
        split_command = split_rows .. split_command
    end

    -- add a trailing '/' if there isn't one. If there is already one don't add
    -- because too many breaks the `term://` syntax
    if #rel_dir == 0 or rel_dir == '' then
        -- no-op
        -- to run a command in the current directory the syntax is
        -- `term://cmd`
    elseif string.sub(rel_dir, #rel_dir, #rel_dir) ~= '/' then
        rel_dir = rel_dir .. "//"
    elseif string.sub(rel_dir, #rel_dir - 1, #rel_dir - 1) ~= '/' then
        rel_dir = rel_dir .. "/"
    end
    vim.cmd(split_command .. ' term://' .. rel_dir .. cmds)
    vim.cmd.norm("A")
    vim.cmd.startinsert()

    if vim.v.shell_error ~= "0" then
        save_cmd_cache(string.gsub(rel_dir, "//$", ""), cmds)
    end
end

function GetPreviouslyRunCommands()
    local ret = {};

    for path, map in pairs(command_cache) do
        for _, cmd in ipairs(map) do
            ret[#ret + 1] = {}
            ret[#ret] = cmd .. " run at " .. path
        end
    end

    return ret;
end

function TelescopeRunCommand()
    if not telescope_status then return end
    local actions = require("telescope.actions")
    local action_state = require "telescope.actions.state"
    local conf = require("telescope.config").values
    local finders = require("telescope.finders")
    local pickers = require "telescope.pickers"

    local entry_maker = function(entry)
        return {
            value = entry,
            display = entry,
            ordinal = entry,
        }
    end

    local results = GetPreviouslyRunCommands()
    results[#results + 1] = "new";
    results[#results + 1] = "new_vert";
    results[#results + 1] = "new_sp";

    local picker_cb = function(split_command)
        return function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()

            if selection.value == "new" then
                M.open_terminal_prompt(nil)
                return
            elseif selection.value == "new_vert" then
                M.open_terminal_prompt("vsplit")
                return
            elseif selection.value == "new_sp" then
                M.open_terminal_prompt("vsplit")
                return
            end

            local split_string = utils.split_string_by_substr(selection.value, " run at ")

            if (#split_string >= 2) then
                local trim = function(s)
                    return string.gsub(s, "^%s*(.-)%s*$", "%1")
                end
                local cmd = trim(split_string[1])
                local path = trim(split_string[2])
                open_terminal(path, cmd, { split_command = split_command or nil })
            end
        end
    end

    pickers.new({}, {
        prompt_title = "Choose command",
        finder = finders.new_table {
            results = results,
            entry_maker = entry_maker
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map({ "i", "n" }, "<C-v>", picker_cb("vsp"))
            map({ "i", "n" }, "<C-x>", picker_cb("sp"))
            map({ "i", "n" }, "<CR>", picker_cb(nil))
            return true
        end
    }):find()
end

function GetCommands(_, _, _)
    fn.inputsave()
    if most_recent_rel_dir == nil or command_cache[most_recent_rel_dir] == nil then
        local result = {}
        if most_recent_rel_dir ~= nil then
            local files_in_dir = utils.getAllFilesInDir(most_recent_rel_dir, false)
            for _, f in ipairs(files_in_dir) do
                local split = utils.split_string(f, '/')
                result[#result + 1] = "./" .. split[#split]
            end
        end
        return result
    end
    local result = {}
    local files_in_dir = utils.getAllFilesInDir(most_recent_rel_dir, false)
    for _, f in ipairs(files_in_dir) do
        local split = utils.split_string(f, '/')
        result[#result + 1] = "./" .. split[#split]
    end

    for _, value in ipairs(command_cache[string.gsub(most_recent_rel_dir, "[//]+$", "")]) do
        result[#result + 1] = value
    end
    fn.inputrestore()
    return result
end

M.open_terminal_prompt = function(split_command)
    local relative_dir = nil
    local command = nil
    if split_command == "rerun" then
        if not (most_recent_cmd and most_recent_rel_dir) then
            print("need to run something first...")
            return
        end

        local rerun_split = most_recent_split or "edit"

        relative_dir = most_recent_rel_dir
        command = most_recent_cmd
    else
        relative_dir = fn.input("relative directory: ", "", "file")
        most_recent_rel_dir = relative_dir

        local opts = {
            prompt = "command to run: ",
            default = "",
            completion = "customlist,v:lua.GetCommands"
        }
        command = fn.input(opts)
        most_recent_cmd = command
        most_recent_split = split_command
    end

    open_terminal(relative_dir, command, { split_command = split_command })
end

vim.api.nvim_create_user_command("Command", function() M.open_terminal_prompt(nil) end, {})
vim.api.nvim_create_user_command("CommandS", function() M.open_terminal_prompt("split") end, {})
vim.api.nvim_create_user_command("CommandV", function() M.open_terminal_prompt("vsplit") end, {})
vim.api.nvim_create_user_command("CommandT", function() M.open_terminal_prompt("tabnew") end, {})
vim.api.nvim_create_user_command("ReRun", function() M.open_terminal_prompt("rerun") end, {})
vim.api.nvim_create_user_command("TR", function() TelescopeRunCommand() end, {})
return M
