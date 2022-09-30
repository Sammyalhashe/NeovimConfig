local status, luasnip = pcall(require, "luasnip")
if not status then return end

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
