local utils = require "utils"
local status1, telescope = pcall(require, "telescope")
local status2, worktree = pcall(require, "git-worktree")
local status3, actions = pcall(require, "telescope.actions")
local status4, Path = pcall(require, "plenary.path")
local status5, job = pcall(require, "plenary.job")
if not (status1 and status2 and status3 and status4 and status5) then return end

-- setup notifications
local notif_status, notify = pcall(require, "notify")
if not notif_status then
    notify = vim.notify
end

local M = {}

local telescope_defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
    prompt_prefix = " ",
    mappings = {
        i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-h>"] = "which_key",
            ["<C-k>"] = "move_selection_previous",
            ["<C-j>"] = "move_selection_next",
            ["<C-q>"] = actions.send_to_qflist,
        },
        n = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-h>"] = "which_key",
            ["<C-k>"] = "move_selection_previous",
            ["<C-j>"] = "move_selection_next",
            ["<C-q>"] = actions.send_to_qflist,
        },
    },
    borderchars = {
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { " " },
    },
}

telescope.setup {
    defaults = telescope_defaults,
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        file_browser = {
            theme = "dropdown",
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                    ["<C-r>"] = function(prompt_buffer)
                        local action_state = require "telescope.actions.state"
                        local current_selection = action_state.get_selected_entry()

                        if current_selection then
                            job:new({
                                "sh", "-c", current_selection[1],
                                on_stdout = function(err, data)
                                    if not err then
                                        notify(data)
                                    end
                                end
                            }):sync()
                        end
                    end
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
    }
}

worktree.setup()
telescope.load_extension("git_worktree")
worktree.on_tree_change(function(op, metadata)
    if op == worktree.Operations.Switch then
        notify("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
        --> Run Makeit function defined in defaults.vim (doesn't exist right now)
        -- job:new({
        --     "make",
        --     on_stdout = function(err, data)
        --         if not err then
        --             notify(data)
        --         end
        --     end
        -- }):sync()
    end
end)

local setup_initializations = function()
    local tcfg = "<cmd>lua require('my_telescope_ext')"
    local tbi = "<cmd>lua require('telescope.builtin')"
    local tex = "<cmd>lua require('telescope').extensions"
    local cr = "<cr>"
    local extensions = { 'fzf', 'file_browser' }

    -- Setup mappings (normal mode)
    utils.map_allbuf('n', '<leader>ff', tbi .. ".find_files()" .. cr)
    utils.map_allbuf('n', '<leader>pf', tbi .. ".git_files()" .. cr)
    utils.map_allbuf('n', '<leader>b', tbi .. ".buffers()" .. cr)
    utils.map_allbuf('n', '<leader>gc', tbi .. ".git_commits()" .. cr)
    utils.map_allbuf('n', '<leader>m', tbi .. ".man_pages()" .. cr)
    utils.map_allbuf('n', '<leader>wc', tex .. ".git_worktree.git_worktrees()" .. cr)
    utils.map_allbuf('n', '<leader>wn', tex .. ".git_worktree.create_git_worktree()" .. cr)
    utils.map_allbuf('n', '<leader>fb', tex .. ".file_browser.file_browser()" .. cr)
    utils.map_allbuf('n', '<leader>sa', tcfg .. ".find_sah_marks()" .. cr)
    utils.map_allbuf('n', '<leader>ag', tcfg .. ".git_files_grep_symbol()" .. cr)

    -- setup extensions
    for _, extension in ipairs(extensions) do
        telescope.load_extension(extension)
    end
end


setup_initializations()

return M
