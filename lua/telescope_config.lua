local utils = require'utils'
local telescope = require'telescope'
local actions = require'telescope.actions'
telescope.setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    prompt_prefix = 'Sammy needs what? ',
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
        ["<C-q>"] = actions.send_to_qflist,
      }
    }
  },
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
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = false,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
    },
    file_browser = {
      theme = "ivy",
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  }
}

local Worktree = require'git-worktree'
Worktree.setup()
telescope.load_extension("git_worktree")
Worktree.on_tree_change(function(op, metadata)
    if op == Worktree.Operations.Switch then
        print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
    end
end)

local setup_initializations = function()
    local tbi = "<cmd>lua require('telescope.builtin')"
    local tex = "<cmd>lua require('telescope').extensions"
    local cr = "<cr>"
    local extensions = {'fzf', 'file_browser'}

    -- Setup mappings (normal mode)
    utils.map_allbuf('n', '<leader>f', tbi .. ".find_files()" .. cr)
    utils.map_allbuf('n', '<leader>e', tbi .. ".git_files()" .. cr)
    utils.map_allbuf('n', '<leader>b', tbi .. ".buffers()" .. cr)
    utils.map_allbuf('n', '<leader>ag', tbi .. ".live_grep()" .. cr)
    utils.map_allbuf('n', '<leader>g', tbi .. ".git_commits()" .. cr)
    utils.map_allbuf('n', '<leader>m', tbi .. ".man_pages()" .. cr)
    utils.map_allbuf('n', '<leader>wc', tex .. ".git_worktree.git_worktrees()" .. cr)
    utils.map_allbuf('n', '<leader>fb', tex .. ".file_browser.file_browser()" .. cr)

    for _, extension in ipairs(extensions) do
        telescope.load_extension(extension)
    end
end

setup_initializations()
