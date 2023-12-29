local status1, autopairs_cmp = pcall(require, "nvim-autopairs.completion.cmp")
local status2, cmp = pcall(require, "cmp")
local status3, luasnip = pcall(require, "luasnip")
local status4, _handlers = pcall(require, "nvim-autopairs.completion.handlers")
if not (status1 and status2 and status3 and status4) then return end

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s") == nil
end

cmp.setup {
    view = {
        entries = {
            native = true,
        },
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        -- If you want tab completion :'(
        --  First you have to just promise to read `:help ins-completion`.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    -- Youtube:
    --    the order of your sources matter (by default). That gives them priority
    --    you can configure:
    --        keyword_length
    --        priority
    --        max_item_count
    --        (more?)
    sources = {
        -- { name = "gh_issues" },

        { name = "emoji",    insert = true },
        -- Youtube: Could enable this only for lua, but nvim_lua handles that already.
        { name = "nvim_lua" },
        { name = "zsh" },
        { name = "orgmode" },
        { name = "nvim_lsp", priority = 100 }, -- lsp results on top
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer",   keyword_length = 5 },
        { name = "neorg" },
    },

    -- Youtube: mention that you need a separate snippets plugin
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = function(entry, vim_item)
            -- set a name for each source
            vim_item.menu = ({
                buffer = "",
                emoji = "",
                nvim_lsp = "⚡",
                path = "",
                spell = "﬜",
                treesitter = "",
                nvim_lua = "",
                orgmode = "",
                neorg = "",
            })[entry.source.name]
            return vim_item
        end,
    },

    experimental = {
        -- Let's play with this for a day or two
        ghost_text = true,
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
        -- completion = {
        --     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        --     col_offset = -3,
        --     side_padding = 0,
        -- },
    }
}

-- autopairs
cmp.event:on(
    "confirm_done",
    autopairs_cmp.on_confirm_done({
        ["*"] = {
            ["("] = {
                kind = {
                    cmp.lsp.CompletionItemKind.Function,
                    cmp.lsp.CompletionItemKind.Method,
                },
                handler = _handlers["*"]
            }
        },
    })
)
