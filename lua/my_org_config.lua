--> NOTE: No need to check if org exists here, since this file should only be
--  included with orgmode.rc.lua.

local _org_default_inbox = nil
local _org_base_directory = nil
local _org_default_notes = nil
if (vim.g.os == "Linux" and vim.g.wsl == true) then
    _org_base_directory = "/mnt/c/Users/sammy/"
    _org_default_inbox = _org_base_directory .. 'Dropbox/Org/Orgzly/inbox.org'
    _org_default_notes = _org_base_directory .. 'Dropbox/Org/Orgzly/notes.org'
else
    if vim.g.os == "Darwin" and vim.g.bb == true then
        _org_base_directory = "~/Desktop/DesktopHolder/what-ive-learned/"
        _org_default_inbox = _org_base_directory .. 'README.org'
        _org_default_notes = _org_base_directory .. 'notes.org'
    else
        _org_base_directory = "~/Dropbox/Org/Orgzly/"
        _org_default_inbox = _org_base_directory .. 'inbox.org'
        _org_default_notes = _org_base_directory .. 'notes.org'
    end
end

--> Commands that will open my important directories directory.
local dir_mappings = {}
dir_mappings["Zshrc"] = "~/.zshrc"
dir_mappings["Nvim"] = "~/.config/nvim/"
dir_mappings["Org"] = _org_default_inbox
dir_mappings["Journal"] = _org_base_directory .. "journal"

function OpenDir(name)
    return function()
        vim.api.nvim_command("edit " .. dir_mappings[name])
        vim.api.nvim_command("cd %:h")
    end
end

local opts = {
}

for key, _ in pairs(dir_mappings) do
    vim.api.nvim_create_user_command("Open" .. key, OpenDir(key), opts)
end

return {
    org_agenda_files = { _org_default_inbox, _org_default_notes,
        '~/Desktop/DesktopHolder/what-ive-learned/**/*' },
    org_default_notes_file = _org_default_inbox,
    -- org_hide_leading_stars = true,
    org_todo_keywords = { 'TODO(t)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)' },
    org_todo_keyword_faces = {
        -- WAITING = ':foreground blue :weight bold',
        -- DELEGATED = ':background #FFFFFF :slant italic :underline on',
        -- TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
    },
    -- org_ellipsis = " ==="
    notifications = {
        enabled = true,
        cron_enabled = true,
        repeater_reminder_time = 5,
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
                    vim.loop.spawn('notify-send', { args = { string.format('%s\n%s\n%s', title, subtitle, date) } })
                end
                -- MacOS
                if vim.fn.executable('terminal-notifier') == 1 then
                    vim.loop.spawn('terminal-notifier',
                        { args = { '-title', title, '-subtitle', subtitle, '-message', date } })
                end
            end
        end
    },
    org_capture_templates = {
        w = {
            description = "Work",
            template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
            target = "~/Desktop/DesktopHolder/what-ive-learned/bb/todo.org"
        },

        p = {
            description = "Personal",
            template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
            target = _org_default_inbox
        },
        j = {
            description = "Journal",
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = _org_base_directory .. "journal/" .. os.date("%A_%B_%d_%Y") .. ".org"
        },
    },
    win_split_mode = "float"
}
