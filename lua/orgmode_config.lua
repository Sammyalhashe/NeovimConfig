local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}

require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup_ts_grammar()
require('orgmode').setup({
  org_agenda_files = {'/Users/sammyalhashemi/Dropbox/Org/Orgzly/inbox.org', '/Users/sammyalhashemi/Dropbox/Org/Orgzly/notes.org'},
  org_default_notes_file = '/Users/sammyalhashemi/Dropbox/Org/Orgzly/notes.org',
  -- org_hide_leading_stars = true,
  org_todo_keywords = {'TODO(t)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)'},
  org_todo_keyword_faces = {
    WAITING = ':foreground blue :weight bold',
    DELEGATED = ':background #FFFFFF :slant italic :underline on',
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
  },
  -- org_ellipsis = " ==="
  notifications = {
        enabled = false,
        cron_enabled = true,
        repeater_reminder_time = false,
        deadline_warning_reminder_time = false,
        reminder_time = 10,
        deadline_reminder = true,
        scheduled_reminder = true,
        notifier = function(tasks)
          local result = {}
          for _, task in ipairs(tasks) do
            require('orgmode.utils').concat(result, {
              string.format('# %s (%s)', task.category, task.humanized_duration),
              string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title),
              string.format('%s: <%s>', task.type, task.time:to_string())
            })
          end
          if not vim.tbl_isempty(result) then
            require('orgmode.notifications.notification_popup'):new({ content = result })
          end
        end,
        cron_notifier = function(tasks)
          for _, task in ipairs(tasks) do
            local title = string.format('%s (%s)', task.category, task.humanized_duration)
            local subtitle = string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title)
            local date = string.format('%s: %s', task.type, task.time:to_string())
            -- Linux
            if vim.fn.executable('notify-send') == 1 then
              vim.loop.spawn('notify-send', { args = { string.format('%s\n%s\n%s', title, subtitle, date) }})
            end
            -- MacOS
            if vim.fn.executable('terminal-notifier') == 1 then
              vim.loop.spawn('terminal-notifier', { args = { '-title', title, '-subtitle', subtitle, '-message', date }})
            end
          end
        end
      }
})
require("org-bullets").setup {
    symbols = { "◉", "○", "✸", "✿" }
    -- or a function that receives the defaults and returns a list
    -- symbols = function(default_list)
    --   table.insert(default_list, "♥")
    --   return default_list
    -- end
}

