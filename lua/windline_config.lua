local windline = require('windline')
local helper = require('windline.helpers')
local sep = helper.separators
local b_components = require('windline.components.basic')
local state = _G.WindLine.state
local vim_components = require('windline.components.vim')
local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

-- hl list
local hl_list = {
    Black = { 'white', 'black' },
    White = { 'black', 'white' },
    Inactive = { 'InactiveFg', 'InactiveBg' },
    Active = { 'ActiveFg', 'ActiveBg' },
}

-- object that holds components
local basic = {}
basic.divider = { b_components.divider, '' }

-- vi mode component
basic.vi_mode = function(active)
    local separator1 = active and sep.left_rounded or ''
    return {
        name = 'vi_mode',
        hl_colors = {
            Normal = { 'black', 'red', 'bold' },
            Insert = { 'black', 'green', 'bold' },
            Visual = { 'black', 'yellow', 'bold' },
            Replace = { 'black', 'blue_light', 'bold' },
            Command = { 'black', 'magenta', 'bold' },
            NormalBefore = { 'red', 'black' },
            InsertBefore = { 'green', 'black' },
            VisualBefore = { 'yellow', 'black' },
            ReplaceBefore = { 'blue_light', 'black' },
            CommandBefore = { 'magenta', 'black' },
            NormalAfter = { 'white', 'red' },
            InsertAfter = { 'white', 'green' },
            VisualAfter = { 'white', 'yellow' },
            ReplaceAfter = { 'white', 'blue_light' },
            CommandAfter = { 'white', 'magenta' },
        },
        text = function()
            return {
                { separator1, state.mode[2] .. 'Before' },
                { active and state.mode[1] .. ' ' or '', state.mode[2] },
                { sep.left_rounded, state.mode[2] .. 'After' },
            }
        end,
    }
end

-- file component
basic.file = function(active)
    return {
        name = 'file',
        hl_colors = {
            default = hl_list.White,
        },
        text = function()
            return {
                {b_components.cache_file_icon({ default = '' }), 'default'},
                { active and b_components.cache_file_name('[No Name]', 'unique') or b_components.file_name('[No Name]', 'full'), '' },
                { b_components.file_modified(' '), '' },
                { b_components.cache_file_size(), '' },
            }
        end,
    }
end

-- lsp component
basic.lsp_diagnos = {
    name = 'diagnostic',
    hl_colors = {
        red = { 'red', 'black' },
        yellow = { 'yellow', 'black' },
        blue = { 'blue', 'black' },
    },
    width = 90,
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_error({ format = '  %s' }), 'red' },
                { lsp_comps.lsp_warning({ format = '  %s' }), 'yellow' },
                { lsp_comps.lsp_hint({ format = '  %s' }), 'blue' },
            }
        end
        return ''
    end,
}

-- git component
basic.git = {
    name = 'git',
    width = 90,
    hl_colors = {
        green = { 'green', 'black' },
        red = { 'red', 'black' },
        blue = { 'blue', 'black' },
    },
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { ' ' },
                { git_comps.diff_added({ format = ' %s' }), 'green' },
                { git_comps.diff_removed({ format = '  %s' }), 'red' },
                { git_comps.diff_changed({ format = ' 柳%s' }), 'blue' },
            }
        end
        return ''
    end,
}

-- right component

local default = {
    filetypes={'default'},
    active={
        { ' ', hl_list.Black },
        basic.vi_mode(true),
        basic.file(true),
        { sep.right_rounded, hl_list.Black },
        basic.lsp_diagnos,
        basic.divider,
        { git_comps.git_branch({ icon = '  ' }), { 'green', 'black' }, 90 },
        { sep.right_rounded, hl_list.Black },
        basic.git,
        basic.right,
    },
    inactive={
        { ' ', hl_list.Black },
        basic.vi_mode(false),
        basic.file(false),
        { sep.right_rounded, hl_list.Black },
        basic.divider,
        { git_comps.git_branch({ icon = '  ' }), { 'green', 'black' }, 90 },
        { sep.right_rounded, hl_list.Black },
    },
    always_active = true,
}

windline.setup({
  statuslines = {
      default,
  },
  colors_name = function(colors)
      --- add new colors
      colors.FilenameFg = colors.white_light
      colors.FilenameBg = colors.black

      -- this color will not update if you change a colorscheme
      colors.gray = "#fefefe"

      -- dynamically get color from colorscheme hightlight group
      local searchFg, searchBg = require('windline.themes').get_hl_color('Search')
      colors.SearchFg = searchFg or colors.white
      colors.SearchBg = searchBg or colors.yellow

      return colors
  end,
})
