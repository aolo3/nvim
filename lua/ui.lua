vim.o.guifont = "Liberation Mono, JetbrainsMono Nerd Font Mono:h16"
vim.o.winborder = "single"

if vim.g.neovide then
	-- vim.g.neovide_fullscreen = true

	vim.keymap.set("n", "<C-=>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
	end, { desc = "Neovide zoom in" })

	vim.keymap.set("n", "<C-0>", function()
		vim.g.neovide_scale_factor = 1.0
	end, { desc = "Neovide reset zoom" })

	vim.keymap.set("n", "<C-->", function()
		vim.g.neovide_scale_factor = math.max(1.5, vim.g.neovide_scale_factor - 0.1)
	end, { desc = "Neovide zoom out" })

	-- vim.g.neovide_scroll_animation_length = 0.0
	vim.g.neovide_cursor_animation_length = 0.07

	-- Disabilita la scia(trail) del cursore
	vim.g.neovide_cursor_trail_size = 0.5

	-- Disabilita eventuali effetti visivi speciali del cursore (es. particelle, botole, ecc.)
	-- vim.g.neovide_cursor_vfx_mode = ""
end
