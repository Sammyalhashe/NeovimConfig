local builtin = require "telescope.builtin"
local Job = require "plenary.job"
local utils = require "utils"
local M = {}

function M.find_sah_marks()
    builtin.grep_string({
        prompt_title = "Stuff Sammy Changed",
        search = "@sah -- start",
    })
end

function M.git_files_grep_symbol()
    local ignored_directories = {}
    Job:new({
        "git", "worktree", "list",
        on_stdout = function(_, data)

            for worktree in data:gmatch("%S+") do
                print(worktree)
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

return M
