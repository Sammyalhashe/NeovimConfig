local status, sniprun = pcall(require, "sniprun")
if not status then return end

local utils = require "utils"

local sa = require('sniprun.api')


sniprun.setup({
    display = {
        -- "VirtualText",
        "Classic",
        "Api",
    },
    interpreter_options = {
        OrgMode_original = {
            default_filetype = 'bash' -- default filetype/language name
        },
        Python3_original = {
            interpreter = utils.valueOrDefault(vim.g.python_interpreter, "python3")
        }
    }
})


local function find_node_ancestor(types, node)
    if not node then
        return nil
    end

    if vim.tbl_contains(types, node:type()) then
        return node
    end

    local parent = node:parent()
    return find_node_ancestor(types, parent)
end

local custom_function = function(d)
    local currNode = vim.treesitter.get_node()
    if currNode == nil  then
        return
    end
    local parent = currNode:parent()
    if parent == nil then
        return
    end
    local row, col, _ = parent:end_()

    local _, line, curcol, _ = vim.fn.getpos('.')
    local message_split =  utils.split_string(d.message, '\n')
    vim.api.nvim_buf_set_lines(0, row, row, false, message_split)
end

sa.register_listener(custom_function)
