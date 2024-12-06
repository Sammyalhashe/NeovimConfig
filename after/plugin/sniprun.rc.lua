local status, sniprun = pcall(require, "sniprun")
if not status then return end

local utils = require "utils"

sniprun.setup({
    interpreter_options = {
        OrgMode_original = {
            default_filetype = 'bash' -- default filetype/language name
        },
        Python3_original = {
            interpreter = utils.valueOrDefault(vim.g.python_interpreter, "python3")
        }
    }
})
