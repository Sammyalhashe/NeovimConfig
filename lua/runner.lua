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

local custom_notify = function(data, level)
    return notify.async(data, level, {
        title = "Runner",
        render = "compact",
        animation = "slide",
        timeout = false,
        hide_from_history = false
    })
end

local client_notifs = {}

local get_notif_data = function(id)
    if not client_notifs[id] then
        client_notifs[id] = {}
    end
    return client_notifs[id]
end

local replace = function (id, data, level)
    local notif_data = get_notif_data(id)
    print(notif_data["notification"])
    if not notif_data["notification"] then
        notif_data["notification"] = custom_notify(data, level)
        return
    end
    notif_data["notification"] = notify.async(data, level, {
        hide_from_history = true,
        replace = notif_data["notification"]
    })
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
            -- TODO: Go through each instruction and run it.
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
                print(vim.inspect(split_instr), args, split_instr[1])
                async.run(function()
                    job:new({
                        split_instr[1], args,
                        on_stdout = function (err, data)
                            if not err then
                                replace(1, data, vim.log.levels.INFO)
                            end
                        end,
                        on_exit = function(j, return_val)
                            replace(1, "command " .. instr .. " done")
                            if return_val ~= 0 then
                                notify(j:result(), vim.log.levels.ERROR)
                            end
                        end
                    }):sync(1000000)
                end)
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
            command, file,
            on_stdout = function(err, data)
                if not err then
                    custom_notify(data, vim.log.levels.INFO)
                end
            end,
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    custom_notify(j:result(), vim.log.levels.ERROR)
                end
            end,
            on_stderr = function(err, data)
                if not err then
                    custom_notify(vim.inspect(data), vim.log.levels.ERROR)
                end
            end
        }):start()
    end

end

return M
