local utils = require("utils")

local job_status, job = pcall(require, "plenary.job")
if not job_status then return end

local async_status, async = pcall(require, "plenary.async")
if not async_status then return end

-- setup notifications
local notif_status, notify = pcall(require, "notify")

if not notif_status then
    notify = vim.notify
end

local function job_with_notify(cmd, last)
    local notification
    print(last)
    local notif_timeout
    if last then
        notif_timeout = 5000
    else
        notif_timeout = false
    end

    -- NOTE: defers callback until NVIM's API is safe to call.
    local notify_output = vim.schedule_wrap(function(data, level)
            if not notification then
                notification = notify(data, level, {
                        title = "Runner",
                        render = "compact",
                        animation = "slide",
                        timeout = notif_timeout,
                        minimum_width = 500,
                        max_height = 100
                    })
                return
            end
            notification = notify(data, level, {
                    hide_from_history = true,
                    replace = notification,
                    minimum_width = 500,
                    max_height = 100
                })
        end)
    job:new({
        command = table.remove(cmd, 1),
        args = cmd,
        on_stdout = function(err, data)
            if not err then
                notify_output(data)
            end
        end,
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                notify(j:result(), vim.log.levels.ERROR)
            end
        end,
    }):start()
end

-- module level variables
local build_directions = {}

local M = {}

function M.setup(opts)
    if opts.build_directions then
        build_directions = opts.build_directions
    end
end

function M.get_current_file()
    -- Returns the current filepath and filetype for current buffer.
    return vim.fn.expand("%:p")
end

function M.get_current_working_directory()
    return vim.fn.getcwd()
end

function M.run(file, filetype)
    -- TODO: given a filepath and filetype runs the file.
    local command = nil

    if filetype == "python" then
        command = "python3"
    elseif filetype == "javascript" then
        command = "node"
    elseif filetype == "typescript" then
        command = "node"
    elseif filetype == "cpp" or filetype == "make" or filetype == "cmake" then
        -- get cwd
        local cwd = M.get_current_working_directory()
        -- TODO: see if there is a project build strategy that you should be able to configure
        if build_directions[cwd] ~= nil then
            local instructions = build_directions[cwd]

            local instructions_size = 0
            for _, _ in pairs(instructions) do
                instructions_size = instructions_size + 1
            end

            -- TODO: Go through each instruction and run it.
            local instruction_idx = 0
            for _, instr in pairs(instructions) do
                local split_instr = utils.split_string(instr, " ")
                local args = ""
                for idx, v in pairs(split_instr) do
                    if idx ~= 1 then
                        if idx ~= 2 then
                            args = args .. " "
                        end
                        args = args .. v
                    end
                end
                job_with_notify(split_instr, instruction_idx == (instructions_size - 1))
                instruction_idx = instruction_idx + 1
            end
            return
        end
        -- TODO: see if a Makefile exists, if it does run `make`
        -- TODO: See if CMakeLists.txt, cmakelists.txt, etc.. exist and run:
        -- `mdkir -p build && cd build && cmake .. && make;`
    elseif filetype == "lua" then
        command = "lua"
    else
        notify("Unable to run filetype", "error")
        return
    end

    if command ~= nil then
        job:new({
            command,
            file,
            on_stdout = function(err, data)
                if not err then
                    notify(data, vim.log.levels.INFO)
                end
            end,
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    notify(j:result(), vim.log.levels.ERROR)
                end
            end,
            on_stderr = function(err, data)
                if not err then
                    notify(vim.inspect(data), vim.log.levels.ERROR)
                end
            end
        }):start()
    end
end

return M
