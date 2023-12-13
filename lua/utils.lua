local M = {}

local io = require("io")

--> Check whether the current buffer is empty
function M.is_buffer_empty()
    return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

--> create a buffer local mapping
function M.map(type, key, value)
    vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true });
end

--> sets a global keymapping for the given vim 'mode' 
function M.map_allbuf(mode, key, value)
    vim.api.nvim_set_keymap(mode, key, value, { noremap = true, silent = true });
end

--> print a given lua table, 'table'
function M.printTable(table)
    for k, v in pairs(table) do
        print(k, " -- ", v)
    end
end

--> split a given 'inputstr' by the given 'sep'
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

--> Custom Lsp rename
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

--> Given a unix 'filepath', expand it to an absolute path
function M.expandFilePath(filepath)
    return vim.fn.expand(filepath)
end

--> mkdir
function M.mkdir(path, flags, prot)
    vim.fn.mkdir(M.expandFilePath(path), flags, prot)
end

--> return a boolean indicating that a given file 'path' exists
--> 'path' can be both absolute and relative.
function M.file_exists(path)
    local f=io.open(M.expandFilePath(path),"r")
    if f~=nil then io.close(f) return true else return false end
end

--> return if a string 'str' contains a substring 'pattern'
function M.string_contains(str, pattern)
    return string.find(str, pattern) ~= nil
end


function M.getAllFilesInDir(path, directories)
    local args = M.expandFilePath(path)
    if directories then
        args = args .. "*/"
    else
        args = args .. "[a-zA-Z]*.[a-zA-Z]*"
    end
    return vim.fn.split(vim.fn.glob(args))
end

function M.createFile(path, name)
    path = M.expandFilePath(path)
    local ok, fd = pcall(vim.loop.fs_open, path .. "/" .. name, "w", 420)
    if not ok then
        print("Unable to create the file")
        return false
    end
    return true
end

function M.entryInTable(entry, table)
    for _, v in ipairs(table) do
        if v == entry then
            return true
        end
    end
    return false
end

function M.replaceSubString(string, substr, with)
    return string:gsub(substr, with)
end

function M.valueOrDefault(value, default)
    if not value then
        return default
    end
    return value
end

function M.makeScratch (scratchpath)
  local uri = vim.uri_from_fname(scratchpath)
  local bufnr = vim.uri_to_bufnr(uri)
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].buflisted = true
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].readonly = false
  vim.bo[bufnr].swapfile = false
  return bufnr
end

function M.clearBufferContents(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    for i = 0, #lines - 1 do
        vim.api.nvim_buf_set_lines(bufnr, i, i, true, {})
    end
end


function M.readFileSync(path)
    local fd = assert(vim.uv.fs_open(path, "r", 438))
    local stat = assert(vim.uv.fs_fstat(fd))
    local data = assert(vim.uv.fs_read(fd, stat.size, 0))
    assert(vim.uv.fs_close(fd))
    return data
end

function M.writeFileSync(path, data, start)
    local fd = assert(vim.uv.fs_open(path, "a+", 438))
    local offset = assert(vim.uv.fs_write(fd, data, start or -1))
    assert(vim.uv.fs_close(fd))
    return offset
end


return M
