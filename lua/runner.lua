local job_status, job = pcall(require, "plenary.job")
if not job_status then return end

local utils = require("utils")

-- setup notifications
local notif_status, notify = pcall(require, "notify")

if not notif_status then
    notify = vim.notify
end

notify = function(data, level)
    notify(data, level, {
        title = "Runner",
        render = "compact",
        animation = "slide"
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
                job:new({
                    split_instr[1], args,
                    on_exit = function(j, return_val)
                        if return_val ~= 0 then
                            notify(j:result(), vim.log.levels.ERROR)
                        end
                    end
                }):sync(50000)
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
