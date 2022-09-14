local status, nvim_autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

-- NOTE: There is some setup to configure autopairs in nvim_cmp file.

nvim_autopairs.setup {

}
