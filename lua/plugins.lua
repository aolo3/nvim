vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/nvim-mini/mini.ai",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/nvim-mini/mini.splitjoin",
	"https://github.com/folke/flash.nvim",
	"https://github.com/abecodes/tabout.nvim",
	"https://github.com/mrjones2014/legendary.nvim",
	"https://github.com/folke/persistence.nvim",
	"https://github.com/zbirenbaum/neodim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/overseer.nvim",
	"https://github.com/jake-stewart/multicursor.nvim",

	-- DAP
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio", -- dipendenza obbligatoria di dap-ui
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
})
require("mason").setup()
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
	ensure_installed = { "lua_ls", "stylua", "clangd", "clang-format", "jsonls", "yamlls" },
})
require("onedarkpro").setup({ options = { cursorline = true } })
vim.cmd("colorscheme onedark")
require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })
require("mini.surround").setup({ mappings = { add = "s", delete = "ds", replace = "cs" } })

require("persistence").setup()
require("flash").setup()
require("which-key").setup({
	preset = "helix",
})

require("neodim").setup({
	alpha = 0.5, -- make the dimmed text even dimmer
	hide = {
		virtual_text = false,
		signs = false,
		underline = false,
	},
})

require("multicursor-nvim").setup()

require("fidget").setup({})
require("lazydev").setup({})

require("blink.cmp").setup({
	snippets = {
		preset = "default",
	},

	appearance = {
		-- sets the fallback highlight groups to nvim-cmp's highlight groups
		-- useful for when your theme doesn't support blink.cmp
		-- will be removed in a future release, assuming themes add support
		use_nvim_cmp_as_default = false,
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		accept = {
			-- experimental auto-brackets support
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = {
			enabled = vim.g.ai_cmp,
		},
	},

	-- experimental signature help support
	signature = {
		enabled = true,
		window = {
			show_documentation = true,
		},
	},

	sources = {
		-- adding any nvim-cmp sources here will enable them
		-- with blink.compat
		default = { "lsp", "path", "snippets", "buffer" },
	},

	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},

	keymap = {
		preset = "enter",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-Space>"] = { "show", "fallback" },
		["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
	},
})

require("oil").setup({
	-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
	default_file_explorer = true,
	-- Id is automatically added at the beginning, and name at the end
	-- See :help oil-columns
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- Buffer-local options to use for oil buffers
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	-- Window-local options to use for oil buffers
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = true,
	-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
	skip_confirm_for_simple_edits = false,
	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
	-- (:help prompt_save_on_select_new_entry)
	prompt_save_on_select_new_entry = true,
	-- Oil will automatically delete hidden buffers after this delay
	-- You can set the delay to false to disable cleanup entirely
	-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		-- Enable or disable LSP file operations
		enabled = true,
		-- Time to wait for LSP file operations to complete before skipping
		timeout_ms = 5000,
		-- Set to true to autosave buffers that are updated with LSP willRenameFiles
		-- Set to "unmodified" to only save unmodified buffers
		autosave_changes = false,
	},
	-- Constrain the cursor to the editable parts of the oil buffer
	-- Set to `false` to disable, or "name" to keep it on the file names
	constrain_cursor = "editable",
	-- Set to true to watch the filesystem for changes and reload oil
	watch_for_changes = true,
	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
	-- Additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("oil.actions").<name>
	-- Set to `false` to remove a keymap
	-- See :help oil-actions for a list of all available actions
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		-- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-h>"] = false,
		-- ["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-t>"] = false,
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		-- ["<C-l>"] = "actions.refresh",
		["<C-l>"] = false,
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
	-- Set to false to disable all of the above keymaps
	use_default_keymaps = true,
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = true,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			local m = name:match("^%.")
			return m ~= nil
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names with numbers in a more intuitive order for humans.
		-- Can be "fast", true, or false. "fast" will turn it off for large directories.
		natural_order = "fast",
		-- Sort file and directory names case insensitive
		case_insensitive = false,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
		-- Customize the highlight group for the file name
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	-- Extra arguments to pass to SCP when moving/copying files over SSH
	extra_scp_args = {},
	-- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
	extra_s3_args = {},
	-- EXPERIMENTAL support for performing file operations with git
	git = {
		-- Return true to automatically git add/mv/rm files
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return false
		end,
		rm = function(path)
			return false
		end,
	},
	-- Configuration for the floating window in oil.open_float
	float = {
		-- Padding around the floating window
		padding = 2,
		-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		max_width = 0,
		max_height = 0,
		border = nil,
		win_options = {
			winblend = 0,
		},
		-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
		get_win_title = nil,
		-- preview_split: Split direction: "auto", "left", "right", "above", "below".
		preview_split = "auto",
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
	-- Configuration for the file preview window
	preview_win = {
		-- Whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
		-- How to open the preview window "load"|"scratch"|"fast_scratch"
		preview_method = "fast_scratch",
		-- A function that returns true to disable preview on a file e.g. to avoid lag
		disable_preview = function(filename)
			return false
		end,
		-- Window-local options to use for preview window buffers
		win_options = {},
	},
	-- Configuration for the floating action confirmation window
	confirmation = {
		-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a single value or a list of mixed integer/float types.
		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
		max_width = 0.9,
		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
		min_width = { 40, 0.4 },
		-- optionally define an integer/float for the exact width of the preview window
		width = nil,
		-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_height and max_height can be a single value or a list of mixed integer/float types.
		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
		max_height = 0.9,
		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
		min_height = { 5, 0.1 },
		-- optionally define an integer/float for the exact height of the preview window
		height = nil,
		border = nil,
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating progress window
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = nil,
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating SSH window
	ssh = {
		border = nil,
	},
	-- Configuration for the floating keymaps help window
	keymaps_help = {
		border = nil,
	},
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("snacks").setup({
	---@type snacks.Config
	lazygit = {},
	input = {
		enabled = true,
		win = {
			relative = "cursor", -- Ancora la finestra al cursore
			row = 1, -- Appare esattamente una riga sotto
			col = 0,
			width = 40, -- Larghezza del popup
			border = "rounded", -- Bordi arrotondati
			title_pos = "left", -- Titolo allineato a sinistra
			backdrop = false, -- Disattiva l'oscuramento dello sfondo
			-- b = {
			-- 	completion = true,
			-- },
		},
	},
	picker = {
		layout = {
			preset = "ivy",
		},
		sources = {
			files = { hidden = true, ignored = false },
			grep = { hidden = true, ignored = false },
		},
	},

	terminal = {},
})

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			-- ['@class.outer'] = '<c-v>', -- blockwise
		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
})

-- DAP SETUP
require("mason-nvim-dap").setup({
	automatic_installation = true,
	ensure_installed = { "codelldb" }, -- per C/C++/Rust, dato che usi clangd. Aggiungi "debugpy" per Python, "delve" per Go, ecc.
	handlers = {},              -- essenziale: senza questa riga l'installazione automatica non configura dap-adapters
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

-- Apri/chiudi la UI automaticamente quando parte/finisce una sessione di debug
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapStopped",
	{ text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
)

vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#5c6370" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e06c75" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4b1818" })

require("overseer").setup({
	-- 2. Quando un task parte, apri AUTOMATICAMENTE l'output in un vertical split a destra
	component_aliases = {
		default = {
			{ "open_output", direction = "vertical", on_start = "always" },
		},
	},

	-- 3. Se apri l'output MANUALMENTE dalla sidebar dei task (OverseerToggle)
	task_list = {
		direction = "right", -- Posiziona anche la sidebar di Overseer a destra
		bindings = {
			["<CR>"] = "open_vsplit", -- Premendo Invio apre l'output in split verticale
		},
	},
})

require("legendary").setup({
	commands = function()
		local legendary_cmds = {}

		local nvim_cmds = vim.api.nvim_get_commands({})

		for cmd_name, _ in pairs(nvim_cmds) do
			table.insert(legendary_cmds, {
				":" .. cmd_name,
				description = "Comando Neovim: " .. cmd_name,
			})
		end

		return legendary_cmds
	end,
})

require("tabout").setup({})
