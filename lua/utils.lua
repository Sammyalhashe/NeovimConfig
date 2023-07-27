local M = {}

local io = require("io")

function M.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

function M.map(type, key, value)
    vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true });
end

function M.map_allbuf(type, key, value)
    vim.api.nvim_set_keymap(type, key, value, { noremap = true, silent = true });
end

function M.printTable(table)
    for k, v in pairs(table) do
        print(k, " -- ", v)
    end
end

function M.split_string(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- rename
function M.rename()
    local position_params = vim.lsp.util.make_position_params()
    local new_name = vim.fn.input " rename to  "
    if new_name and new_name ~= "" then
        position_params.newName = new_name
        vim.lsp.buf_request(
            0,
            "textDocument/rename",
            position_params,
            function(err, method, result, ...)
                if method.changes then
                    local entries = {}
                    for uri, edits in pairs(method.changes) do
                        local bufnr = vim.uri_to_bufnr(uri)
                        for _, edit in ipairs(edits) do
                            table.insert(entries, {
                                bufnr = bufnr,
                                lnum = edit.range.start.line + 1,
                                col = edit.range.start.character + 1,
                                text = edit.newText
                            })
                        end
                    end
                    vim.fn.setqflist(entries, 'r')
                end
                vim.lsp.handlers["textDocument/rename"](err, method, result, ...)
            end
        )
    end
end

function M.expandFilePath(filepath)
    return vim.fn.expand(filepath)
end

function M.mkdir(path, flags, prot)
    vim.fn.mkdir(M.expandFilePath(path), flags, prot)
end

function M.file_exists(path)
    local f=io.open(M.expandFilePath(path),"r")
    if f~=nil then io.close(f) return true else return false end
end


function M.string_contains(str, pattern)
    return string.find(str, pattern) ~= nil
end

return M
