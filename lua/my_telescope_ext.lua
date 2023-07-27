local status, builtin = pcall(require, "telescope.builtin")
local status1, job = pcall(require, "plenary.job")
if not (status and status1) then return end

local utils = require "utils"

-- define modules
local M = {}

function M.find_sah_marks()
    builtin.grep_string({
        prompt_title = "Stuff Sammy Changed",
        search = "@sah -- start",
    })
end

function M.git_files_grep_symbol()
    local ignored_directories = {}
    job:new({
        "git", "worktree", "list",
        on_stdout = function(_, data)

            for worktree in data:gmatch("%S+") do
                local split_string = utils.split_string(worktree, "/")
                local size = #split_string
                local escaped_string, _ =
                split_string[size]:gsub("%[", ""):gsub("%]", "")
                table.insert(ignored_directories, "!" .. escaped_string)
            end
        end
    }):sync()

    builtin.live_grep({
        glob_pattern = ignored_directories
    })
end

-- trouble extension
function M.send_to_trouble(telescope_defaults)
    local status2, trouble = pcall(require, "trouble")
    if not status2 then return end

    print(vim.inspect(telescope_defaults["mappings"]["i"]))
    telescope_defaults["mappings"]["i"]["<C-t>"] = 1
    -- telescope_defaults["mappings"]["n"]["cat"] = trouble.open_with_trouble
    print(vim.inspect(telescope_defaults["mappings"]["i"]))
end

return M
