--> NOTE: No need to check if org exists here, since this file should only be
--  included with orgmode.rc.lua.

local utils = require "utils"

local _org_default_inbox = nil
local _org_base_directory = nil
local _org_default_notes = nil
local _org_journal_dir = nil

_org_base_directory = vim.g.orgmode_base
if not _org_base_directory then
    print("orgmode_base required in local.lua")
    return {}
end

_org_default_inbox = _org_base_directory .. "/" .. "inbox.org"
_org_default_notes = _org_base_directory .. "/" .. "notes.org"
_org_journal_dir = _org_base_directory .. "/" .. "journal/"

--> Commands that will open my important directories directory.
local dir_mappings = {}
dir_mappings["Zshrc"] = "~/.zshrc"
dir_mappings["Nvim"] = "~/.config/nvim/"
dir_mappings["Org"] = _org_default_inbox
dir_mappings["Journal"] = _org_journal_dir

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
        subtemplates = {
            u = {
                description = "Not scheduled",
                template =
                [[* %^{What state?|TODO|TODO|FIX|OPTIMIZE} %n %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:]],
                target = _org_default_inbox
            },
            s = {
                description = "Scheduled",
                template =
                [[* %^{What state?|TODO|TODO|FIX|OPTIMIZE} %n %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:
                %(local hour = vim.fn.input('scheudled hour: ');
                if not hour then return '' else return 'SCHEDULED: <' .. os.date('%Y-%m-%d') .. ' ' .. hour .. ':00' .. '>' end )]],
                target = _org_default_inbox
            },
        }
    },
    j = {
        description = "Journal",
        subtemplates = {
            s = {
                description = "Scheduled",
                template =
                '\n*** %^{What state?||TODO|IDEA|} %U %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:',
                target = utils.valueOrDefault(vim.g.orgmode_journal, _org_journal_dir) ..
                "/" .. os.date("%B_%Y") .. ".org",
            },
            u = {
                description = "Not scheduled",
                template =
                [[*** %^{What state?||TODO|IDEA|} %U %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:]],
                target = utils.valueOrDefault(vim.g.orgmode_journal, _org_journal_dir) ..
                "/" .. os.date("%B_%Y") .. ".org",
            }
        }
    },
    w = {
        description = "Work",
        template = "* %^{State|TODO|TODO|FIX|OPTIMIZE} %n %?\n  %T",
        target = utils.valueOrDefault(vim.g.orgmode_workdir,
            utils.valueOrDefault(vim.g.orgmode_journal, _org_journal_dir) .. "/" .. os.date("%B_%Y") .. ".org"),
    }

}

return {
    org_agenda_files = { _org_default_inbox, _org_default_notes, _org_journal_dir .. "**/*", _org_journal_dir .. "*" },
    org_default_notes_file = _org_default_inbox,
    -- org_hide_leading_stars = true,
    org_todo_keywords = { 'TODO(t)', 'IDEA(t)', 'FIX(f)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)' },
    org_todo_keyword_faces = {
        FIX = ':foreground red',
        IDEA = ':foreground green :weight bold',
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
