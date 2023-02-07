-- TODO: Implement a module that lets you run a file of various languages.
local job_status, job = pcall(require, "plenary.job")
if not job_status then return end

-- setup notifications
local notif_status, notify = pcall(require, "notify")

if not notif_status then
    notify = vim.notify
end

local notify = function(data, level)
    notify(data, level, {
        title = "Runner",
        render = "compact",
        animation = "slide"
    })
end

local M = {}

function M.get_current_file()
    -- TODO: Returns the current filepath and filetype for current buffer.
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
