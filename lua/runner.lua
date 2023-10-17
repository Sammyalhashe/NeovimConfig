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

local function buildTargetPrompt(targets)
    local prompt = ""
    for i, target in pairs(targets) do
        prompt = prompt .. "&" .. i .. " " .. target .. "\n"
    end
    return prompt
end

local function getTargets(cwd, opts)
    if opts.ninja then
        local targets = {}
        job:wait(job:new({
            command = "ninja",
            args = { "-t", "targets", "all" },
            cwd = cwd,
            on_stdout = function(err, data)
                if not err then
                    for _, line in ipairs(utils.split_string(data, "\n")) do
                        targets[#targets + 1] = utils.split_string(utils.replaceSubString(line, ":", ""), " ")[1]
                    end
                end
            end,
            on_exit = function(j, return_val)
                if return_val == 0 then
                end
            end,
        }):start())
        local prompt = buildTargetPrompt(targets)
        print("targets size: " .. #targets)
        for index, value in ipairs(targets) do
            print(index, value)
        end
        local res = vim.fn.confirm("Selected the target to build: ", prompt)
    end
end

local function getCppErrorBuildLineBreakDown(line)
    local filenamePattern = "[-./%w%d_]+"
    local lineAndColumnPattern = "[%d]+:[%d]+"
    local errMessagePattern = "error:[%d%s'%w’‘_]+"
    -- local pattern =  "[\\-./%w_]+:[%d]+:[%d]+: error:[%d%s'%w’‘_]+"

    local filenameMatch = string.match(line, filenamePattern)
    if filenameMatch ~= nil then
        filenameMatch = filenameMatch:gsub(":", "")
    end
    return filenameMatch, string.match(line, lineAndColumnPattern), string.match(line, errMessagePattern)
end

local function job_with_notify(cmd, cwd, last)
    local notification

    -- NOTE: defers callback until NVIM's API is safe to call.
    local notify_output = vim.schedule_wrap(function(data, last_local, level)
        local notif_timeout
        if last_local then
            notif_timeout = 5000
        else
            notif_timeout = false
        end
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
            max_height = 100,
            timeout = notif_timeout,
        })
    end)

    local actual_cmd = table.remove(cmd, 1)
    local args = cmd

    local list = {}
    job:new({
        command = actual_cmd,
        args = args,
        cwd = cwd,
        on_stdout = function(err, data)
            if not err then
                notify_output(data, false)
            end
        end,
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                if #list ~= 0 then
                    vim.schedule(function()
                        vim.fn.setqflist(list)
                    end)
                    notify_output("build failed", true, vim.log.levels.ERROR)
                    return
                end
                local result = j:result()
                if #result ~= 0 then
                    for key, value in ipairs(result) do
                        print(key, value)
                    end
                end
            end
            notify_output("job done", true)
            vim.schedule(function()
                vim.fn.setqflist({})
                vim.cmd.cclose()
            end)
        end,
        on_stderr = function(err, data)
            local filenameMatch, lineNumMatch, errMessageMatch = getCppErrorBuildLineBreakDown(data)

            if filenameMatch ~= nil and lineNumMatch ~= nil and errMessageMatch ~= nil then
                local split_line_column_num = utils.split_string(lineNumMatch, ":")
                list[#list + 1] = {
                    filename = filenameMatch,
                    lnum = split_line_column_num[1],
                    col = split_line_column_num[2],
                    text = errMessageMatch
                }
            end
        end
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

            -- Go through each instruction and run it.
            local instruction_idx = 0
            for _, instr in pairs(instructions) do
                local modified_cwd = cwd
                if instr.cwd ~= nil then
                    modified_cwd = utils.replaceSubString(instr.cwd, "|workdir|", cwd)
                end
                local split_instr = utils.split_string(instr.cmd, " ")

                -- if the command defines targets, ask the user which one should be run
                if instr.targets ~= nil then
                    local prompt = buildTargetPrompt(instr.targets)
                    local res = vim.fn.confirm("Choose target to build: ", prompt)
                    split_instr[#split_instr + 1] = instr.targets[res]
                end
                job_with_notify(split_instr, modified_cwd, instruction_idx == (instructions_size - 1))
                instruction_idx = instruction_idx + 1
            end
            return
        end
        -- see if a Makefile exists, if it does run `make`
        -- See if CMakeLists.txt, cmakelists.txt, etc.. exist and run:
        -- `mdkir -p build && cd build && cmake .. && make;`
        local make_exists = utils.file_exists(cwd .. "/Makefile") or utils.file_exists(cwd .. "/makefile")
        if make_exists then
            local instructions = { "make" }
            job_with_notify(instructions, cwd, true)
            return
        end
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
