local builtin = require"telescope.builtin"
local M = {}

function M.find_sah_marks()
    builtin.grep_string({
        prompt_title = "Stuff Sammy Changed",
        search = "@sah -- start",
    })
end

return M
