vim.o.termguicolors = true
vim.o.relativenumber = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.number = true
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
vim.diagnostic.config({ virtual_text = true }) -- inline diagnostic

vim.o.shell = "pwsh"

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
