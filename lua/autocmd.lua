local ts = require("nvim-treesitter")
local available_set = {}
for _, l in ipairs(ts.get_available()) do
	available_set[l] = true
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or not available_set[lang] then
			return
		end

		local max_filesize = 1024 * 1024 -- 1MB
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		if ok and stats and stats.size > max_filesize then
			return
		end
		if not vim.tbl_contains(ts.get_installed(), lang) then
			ts.install(lang):wait()
		end
		vim.treesitter.start(ev.buf, lang or ev.match)
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
-- vim.o.updatetime = 700

-- Mostra automaticamente il popup degli errori quando il cursore si ferma su una riga
-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	callback = function()
-- 		local line = vim.api.nvim_win_get_cursor(0)[1] - 1
-- 		if #vim.diagnostic.get(0, { lnum = line }) == 0 then
-- 			return
-- 		end
-- 		vim.diagnostic.open_float(nil, {
-- 			focusable = false,
-- 			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
-- 			border = "rounded",
-- 			source = "always",
-- 			prefix = "",
-- 			header = "",
-- 		})
-- 	end,
-- })

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- Remove trailing whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		if vim.bo.buftype ~= "" or not vim.bo.modifiable then
			return
		end
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Show cursorline only on active windows
vim.api.nvim_create_autocmd({ "WinEnter" }, {
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = false
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
-- 	pattern = "term://*",
-- 	callback = function()
-- 		vim.schedule(function()
-- 			vim.cmd("stopinsert")
-- 		end)
-- 	end,
-- })

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("AutoRestoreSession", { clear = true }),
	nested = true,
	callback = function()
		if vim.fn.argc() == 0 then
			require("persistence").load({ last = true })
		end
	end,
})

-- local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
-- 	group = lint_augroup,
-- 	callback = function()
-- 		require("lint").try_lint()
-- 	end,
-- })
