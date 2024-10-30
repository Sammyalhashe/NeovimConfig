local cmp = require'cmp'
local luasnip = require'luasnip'

vim.opt.completeopt = { "menu", "menuone", "noselect" }


-- TODO: Move this to more appropriate location.
-- custom snippets
-- in luasnip, i(x) nodes are "insert" nodes where you can insert text and
-- jump to. It starts at the 1st node and goes upwards. The 0th node is special
-- as it should be the last. If there is no 0th node it will be implicitly
-- inserted at the end.
local snippet_fts = {}
snippet_fts['cpp'] = '// '
snippet_fts['javascript'] = '// '
snippet_fts['python'] = '# '
snippet_fts['bash'] = '# '
snippet_fts['lua'] = '-- '

for lang, comment_start in pairs(snippet_fts) do
    luasnip.add_snippets(lang, {
        luasnip.s({ trig = "sah" }, {
            luasnip.t({ comment_start .. "@sah -- start: " }), luasnip.i(1),
            -- NOTE: I have to do something like this for newlines
            -- luasnip.t({ "", comment_start .. "" }),
            luasnip.t({ "", "" }),
            luasnip.i(0),
            luasnip.t({ "", comment_start .. "@sah -- end" })
        })
    })
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
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

    -- Youtube: Could enable this only for lua, but nvim_lua handles that already.
    { name = "nvim_lua" },
    { name = "zsh" },
    { name = "orgmode" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5 },
  },

  -- Youtube: mention that you need a separate snippets plugin
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    -- Youtube: How to set up nice formatting for your sources.
  },

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = false,
  },
  window = {
      documentation = cmp.config.window.bordered(),
  }
}
