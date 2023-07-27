--> aliases
local util = require("utils")

--> mappings
if vim.g.bb then
    util.map_allbuf("n", "“", "5<c-w>>")
    util.map_allbuf("n", "‘", "5<c-w><")
    util.map_allbuf("n", "…", "5<c-w>+")
    util.map_allbuf("n", "æ", "5<c-w>-")
else
    util.map_allbuf("n", "<a-]>", "5<c-w>>")
    util.map_allbuf("n", "<a-[>", "5<c-w><")
    util.map_allbuf("n", "<a-'>", "5<c-w>+")
    util.map_allbuf("n", "<a-;>", "5<c-w>-")
end

