local status, neogit = pcall(require, "neogit")
if (not status) then return end

neogit.setup {}

vim.api.nvim_create_user_command("Ng", "Neogit", {})

vim.keymap.set("n", "<leader>gg", "<cmd>Ng<cr>")
