
local M = {}

M.buffer_delete = function(pattern)
    local buffers = vim.api.nvim_list_bufs() -- vim.api.nvim_command('buffers')
    for k, v in pairs(buffers) do
        local bufname = vim.api.nvim_buf_get_name(v)
    end
end

return M
