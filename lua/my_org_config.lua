--> NOTE: No need to check if org exists here, since this file should only be
--  included with orgmode.rc.lua.

local _org_default_inbox = nil
local _org_base_directory = nil
local _org_default_notes = nil
local _org_journal_dir = nil

_org_base_directory = vim.g.orgmode_base
if not _org_base_directory then
    print("_org_base_directory required in local.lua")
    return {}
end

_org_default_inbox = _org_base_directory .. "/" .. "inbox.org"
_org_default_notes = _org_base_directory .. "/" .. "notes.org"

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

local _org_capture_templates = {
    p = {
        description = "Personal",
        template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
        target = _org_default_inbox
    },
}

if vim.g.orgmode_workdir then
    _org_capture_templates.w = {
        description = "Work",
        template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
        target = "~/Desktop/DesktopHolder/what-ive-learned/bb/todo.org"
    }
end

if vim.g.orgmode_journal then
    _org_capture_templates.j = {
        description = "Journal",
        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
        target = _org_journal_dir .. os.date("%A_%B_%d_%Y") .. ".org"
    }
end

return {
    org_agenda_files = { _org_default_inbox, _org_default_notes},
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
    org_capture_templates = _org_capture_templates,
    win_split_mode = "float"
}
