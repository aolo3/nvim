vim.g.mapleader = " "
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader><leader>", ":so<cr>")

vim.keymap.set({ "i", "c" }, "<C-BS>", "<C-w>")
vim.keymap.set({ "i", "c" }, "<C-Backspace>", "<C-w>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

pcall(vim.keymap.del, { "n" }, "grn")
pcall(vim.keymap.del, { "n" }, "grr")
pcall(vim.keymap.del, { "n" }, "gri")
pcall(vim.keymap.del, { "n", "x" }, "gra")
pcall(vim.keymap.del, { "n" }, "grx")
pcall(vim.keymap.del, { "n" }, "grt")

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, { desc = "LSP Signature Help" })

-- Snacks
vim.keymap.set("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "Toggle LazyGit" })

vim.keymap.set("n", "<leader>gf", function()
	Snacks.lazygit.log_file()
end, { desc = "LazyGit File History" })

vim.keymap.set("n", "<leader>gl", function()
	Snacks.lazygit.log()
end, { desc = "LazyGit Log" })

local picker = require("snacks").picker

-- Smart definition or references jump
local function definition_or_references()
	local params = vim.lsp.util.make_position_params(0, "utf-16")
	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			picker.lsp_definitions()
			return
		end
		local items = vim.lsp.util.locations_to_items(result, "utf-16")
		local cur_file = vim.fn.expand("%:p")
		local cur_line = vim.api.nvim_win_get_cursor(0)[1]
		for _, item in ipairs(items) do
			if vim.fn.fnamemodify(item.filename, ":p") == cur_file and item.lnum == cur_line then
				picker.lsp_references()
				return
			end
		end

		picker.lsp_definitions()
	end)
end

-- Pickers & Files
vim.keymap.set("n", "<leader>pf", picker.files, { desc = "Pick file" })
vim.keymap.set("n", "<leader>pw", function()
	picker.grep({ need_search = false, live = false })
end, { desc = "Pick word (Grep)" })

vim.keymap.set("n", "<leader>pp", picker.projects, { desc = "Projects" })

-- LSP Symbols & Commands
vim.keymap.set("n", "<leader>ps", picker.lsp_symbols, { desc = "Pick document symbol" })
vim.keymap.set("n", "<leader>po", function()
	picker.lsp_workspace_symbols({ search = "" })
end, { desc = "Pick workspace symbol" })
vim.keymap.set("n", "<leader>pc", picker.commands, { desc = "Pick commands" })

-- LSP Navigation & Actions
vim.keymap.set("n", "gd", definition_or_references, { desc = "Go to definition" })
vim.keymap.set("n", "gr", picker.lsp_references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Diagnostics
vim.keymap.set("n", "<leader>up", picker.diagnostics, { desc = "Workspace diagnostics" })

-- Git
vim.keymap.set("n", "<leader>gc", picker.git_log, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", picker.git_branches, { desc = "Git branches" })

-- Utilities & Search
vim.keymap.set("n", "<leader>sh", picker.help, { desc = "Help tags" })
vim.keymap.set("n", "<leader>sk", picker.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sC", picker.colorschemes, { desc = "Colorschemes" })
