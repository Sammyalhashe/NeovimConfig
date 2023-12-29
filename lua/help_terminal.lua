local utils = require("utils")

-- alias fn/cmd
local fn = vim.fn


local M = {}


local most_recent_rel_dir = nil
local most_recent_cmd = nil
local command_cache = {}


local open_terminal = function(rel_dir, cmds, opts)
    local split_command = (opts and opts["split_command"]) or "split"
    vim.cmd(split_command .. ' term://' .. rel_dir .. '/' .. cmds)

    if vim.v.shell_error ~= "0" then
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

    for _, value in ipairs(command_cache[most_recent_rel_dir]) do
        result[#result + 1] = value
    end
    fn.inputrestore()
    return result
end

M.open_terminal_prompt = function()
    local relative_dir = fn.input("relative directory: ", "", "file")
    most_recent_rel_dir = relative_dir
    local opts = {
        prompt = "command to run: ",
        default = "",
        completion = "customlist,v:lua.GetCommands"
    }
    local command = fn.input(opts)
    open_terminal(relative_dir, command)
end

vim.api.nvim_buf_set_keymap(0, 'n', '<F7>', ":lua require'help_terminal'.open_terminal_prompt()<CR>",
    { noremap = true, silent = true })
return M
