local status, nightfox = pcall(require, "nightfox")
if (not status) then return end

nightfox.setup {
   options = {
       styles = {
         comments = "italic",
         keywords = "bold",
         types = "italic,bold",
       },
       dim_inactive = true,
   }
}

vim.cmd("colorscheme terafox")
