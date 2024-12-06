--> NOTE: No need to check if org exists here, since this file should only be
--  included with orgmode.rc.lua.

local utils = require "utils"

local _org_default_inbox = nil
local _org_work_inbox = nil
local _org_base_directory = nil
local _org_default_notes = nil
local _org_journal_dir = nil
local _org_work_base_directory

_org_base_directory = utils.valueOrDefault(vim.g.orgmode_personal_base, "~/Orgmode")
_org_work_base_directory = utils.valueOrDefault(vim.g.orgmode_work_base, "~/Orgmode")

_org_default_inbox = _org_base_directory .. "/" .. "inbox.org"
_org_work_inbox = _org_work_base_directory .. "/" .. "inbox.org"
_org_default_notes = _org_base_directory .. "/" .. "notes.org"
_org_journal_dir = _org_base_directory .. "/" .. "journal/"

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
    l = {
        description = "links",
        subtemplates = {
            s = {
                description = "Shopping",
                template = "- [[%^{Link||}]]",
                headline = "Shopping links",
                target = _org_base_directory .. "/links.org",
            },
            r = {
                description = "Useful resource links",
                template = "- [[%^{Link||}]]",
                headline = "Useful resource links",
                target = _org_base_directory .. "/links.org",
            },
            w = {
                description = "Wants",
                template = "- [[%^{Link||}]]",
                headline = "Wants",
                target = _org_base_directory .. "/links.org",
            },
        }
    },
    w = {
        description = "Work",
        subtemplates = {
            u = {
                description = "Not scheduled",
                template =
                [[* %^{What state?|TODO|TODO|FIX|OPTIMIZE} %n %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:]],
                target = _org_work_inbox
            },
            s = {
                description = "Scheduled",
                template =
                [[* %^{What state?|TODO|TODO|FIX|OPTIMIZE} %n %^{Item||}%? :%^{Tag?|personal|coding|sheff|work|travel|tennis|workout|wants}:
                %(local hour = vim.fn.input('scheudled hour: ');
                if not hour then return '' else return 'SCHEDULED: <' .. os.date('%Y-%m-%d') .. ' ' .. hour .. ':00' .. '>' end )]],
                target = _org_work_inbox
            },
        }
    }

}

return {
    org_agenda_files = {
        _org_work_base_directory .. "/**/*",
        _org_base_directory .. "/**/*",
        _org_default_inbox,
        _org_default_notes,
        _org_journal_dir .. "**/*",
        _org_journal_dir .. "*",
        _org_base_directory .. "/notes/*"
    },
    org_default_notes_file = _org_default_inbox,
    -- org_hide_leading_stars = true,
    org_todo_keywords = { 'TODO(t)', 'IDEA(t)', 'FIX(f)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)' },
    org_todo_keyword_faces = {
        FIX = ':foreground red',
        IDEA = ':foreground green :weight bold',
    },
    org_capture_templates = _org_capture_templates,
}
