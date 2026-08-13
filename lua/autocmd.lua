vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		local available_langs = require("nvim-treesitter").get_available()
		local is_available = vim.tbl_contains(available_langs, lang)
		if is_available then
			local installed_langs = require("nvim-treesitter").get_installed()
			local installed = vim.tbl_contains(installed_langs, lang)
			if not installed then
				require("nvim-treesitter").install(lang):wait()
			end
			vim.treesitter.start()
			require("nvim-treesitter").indentexpr()
		end
	end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch", -- Color (eg. IncSearch, Visual, Search)
			timeout = 200,
		})
	end,
})

-- Riduce il tempo di attesa prima che Neovim capisca che ti sei fermato (default è 4000ms, troppo lento)
vim.o.updatetime = 300

-- Mostra automaticamente il popup degli errori quando il cursore si ferma su una riga
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			focusable = false, -- Evita che il focus si sposti dentro il popup (puoi continuare a scrivere)
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = "",
			header = "",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})
