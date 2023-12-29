local status, gitsigns = pcall(require, "gitsigns")
if (not status) then return end

local on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    --> Navigation
    map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function()
            gs.next_hunk({ preview = true })
        end)
        return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function()
            gs.prev_hunk({ preview = true })
        end)
        return '<Ignore>'
    end, { expr = true })

    --> Actions
    map({ 'n', 'v' }, '<leader>gs', gs.stage_hunk)
    map({ 'n', 'v' }, '<leader>gr', gs.reset_hunk)
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', gs.toggle_current_line_blame)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>gn', gs.toggle_deleted)
    map('n', '<leader>gh', gs.next_hunk)
    map('n', '<leader>gH', gs.prev_hunk)
    map('n', '<leader>gtd', gs.toggle_deleted)

    --> Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

gitsigns.setup {
    on_attach = on_attach
}
