local status, luasnip = pcall(require, "luasnip")
if not status then return end

--> custom snippets
--> in luasnip, i(x) nodes are "insert" nodes where you can insert text and
--> jump to. It starts at the 1st node and goes upwards. The 0th node is special
--> as it should be the last. If there is no 0th node it will be implicitly
--> inserted at the end.
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

local applySnippets = function(lang, table)
    for trig, snip_config in pairs(table) do
        local config = {}
        for _, value in ipairs(snip_config) do
            if value[2] == "t" then
                config[#config + 1] = luasnip.t({ value[1] })
            elseif value[2] == "i" then
                config[#config + 1] = luasnip.i(0)
            end
        end
        luasnip.add_snippets(lang, {
            luasnip.s({ trig = trig }, config)
        })
    end
end

--> bash snippets
local bash_snippets = {}

--> get the location of sh
local handle = io.popen("which sh", "r")
if handle then
    local sh = string.gsub(handle:read("*a"), "\n", "")
    handle:close()
    bash_snippets["shebang"] = {}
    bash_snippets["shebang"][#bash_snippets["shebang"] + 1] = { "#! " .. sh, "t" }
end

applySnippets("sh", bash_snippets)

--> python snippets
local python_snippets = {}

--> get the location of python3
handle = io.popen("which python3", "r")
if handle then
    local python3 = string.gsub(handle:read("*a"), "\n", "")
    handle:close()
    python_snippets["shebang"] = {}
    python_snippets["shebang"][#python_snippets["shebang"] + 1] = { "#! " .. python3, "t" }
end

local func_snip = {}
func_snip[1] = { "def function_name():", "t" }
func_snip[2] = { "", "i" }
python_snippets["func"] = func_snip

applySnippets("python", python_snippets)

--> c/cpp snippets
local c_snippets = {}
