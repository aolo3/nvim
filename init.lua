vim.o.termguicolors = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.number = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.softtabstop = 2
vim.o.signcolumn = "yes"
vim.o.undofile = true
vim.o.autoread = true
vim.o.laststatus = 3
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.wrap = false
vim.opt.splitright = true

if vim.fn.has("win32") == 1 then
	local cygwin_choco_bin = "C:\\tools\\cygwin\\bin"
	if vim.fn.isdirectory(cygwin_choco_bin) == 1 and not string.find(vim.env.PATH, cygwin_choco_bin, 1, true) then
		vim.env.PATH = vim.env.PATH .. ";" .. cygwin_choco_bin
	end
end

vim.diagnostic.config({ virtual_text = true }) -- inline diagnostic

require("usercmd")
require("plugins")
require("ui")
require("remaps")
require("autocmd")
-- AUTOCOMMANDS
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = function()
--     if vim.lsp.get_clients({ bufnr = 0 })[1] then
--       vim.lsp.buf.document_highlight()
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
--   callback = vim.lsp.buf.clear_references,
-- })
