-- font
vim.o.guifont = "OperatorMono Nerd Font:h14"

-- resizing font.
local map = vim.keymap.set

local function neovideScale(amount)
	local temp = vim.g.neovide_scale_factor + amount

	if temp < 0.5 then
		return
	end

	vim.g.neovide_scale_factor = temp
end

map("n", "<C-=>", function()
	neovideScale(0.1)
end)

map("n", "<C-->", function()
	neovideScale(-0.1)
end)

-- which particles to use
vim.g.neovide_cursor_vfx_mode = "pixiedust"

-- particle settings
vim.g.neovide_cursor_vfx_opacity = 200.0
vim.g.neovide_cursor_vfx_particle_density = 7.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
