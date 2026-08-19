local cpus = #vim.loop.cpu_info()
local nproc = math.max(1, cpus - 1)

-- ============================================================================
-- 1. PLUGIN INSTALLATION (PACK ADD)
-- ============================================================================

vim.pack.add({

	-- LSP & Mason
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/mason-org/mason-tool-installer.nvim",

	-- Completion & Treesitter
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

	-- UI & Navigation
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/w0ng/vim-hybrid.git",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/j-hui/fidget.nvim",

	-- Mini Utilities
	"https://github.com/nvim-mini/mini.ai",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/nvim-mini/mini.splitjoin",

	-- Editing & Motion
	"https://github.com/folke/flash.nvim",
	"https://github.com/abecodes/tabout.nvim",
	"https://github.com/mrjones2014/legendary.nvim",
	"https://github.com/folke/persistence.nvim",
	"https://github.com/zbirenbaum/neodim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/overseer.nvim",
	"https://github.com/jake-stewart/multicursor.nvim",
	"https://github.com/nvim-lua/plenary.nvim",

	-- Formatting & Linting
	"https://github.com/nvimtools/none-ls.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",

	-- DAP (Debugging)
	"https://github.com/mfussenegger/nvim-dap",
	-- "https://github.com/rcarriga/nvim-dap-ui",
	-- "https://github.com/nvim-neotest/nvim-nio", -- Mandatory dependency for dap-ui
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
})

-- ============================================================================
-- 2. MASON & LSP SETUP
-- ============================================================================

require("mason").setup()
require("mason-lspconfig").setup({})

require("mason-tool-installer").setup({
	ensure_installed = { "lua_ls", "stylua", "clangd", "clang-format", "jsonls", "yamlls" },
})

-- ============================================================================
-- 3. THEME SETUP
-- ============================================================================

require("onedarkpro").setup({ options = { cursorline = true } })
vim.cmd("colorscheme onedark_vivid")
-- require("gruvbox").setup()
-- vim.cmd("set background=dark")
-- vim.cmd("colorscheme hybrid")

-- ============================================================================
-- 4. MINI MODULES SETUP
-- ============================================================================

require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })
require("mini.surround").setup({ mappings = { add = "s", delete = "ds", replace = "cs" } })

-- ============================================================================
-- 5. UTILITIES & MOTION SETUP
-- ============================================================================

require("persistence").setup()
require("flash").setup()
require("which-key").setup({
	preset = "helix",
})

-- require("neodim").setup({
--     alpha = 0.5, -- Make the dimmed text even dimmer
--     hide = {
--         virtual_text = false,
--         signs = false,
--         underline = false,
--     },
-- })

require("multicursor-nvim").setup()
require("fidget").setup({})

-- ============================================================================
-- 6. AUTOCOMPLETION (BLINK.CMP)
-- ============================================================================

require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("blink.cmp").setup({
	snippets = {
		preset = "default",
	},

	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's highlight groups
		-- Useful for when your theme doesn't support blink.cmp
		use_nvim_cmp_as_default = false,
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		accept = {
			-- Experimental auto-brackets support
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

	-- Experimental signature help support
	signature = {
		enabled = true,
		window = {
			show_documentation = true,
		},
	},

	sources = {
		default = {
			"lazydev",
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
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

-- ============================================================================
-- 7. FILE EXPLORER & UI TOOLS
-- ============================================================================

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
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
	delete_to_trash = true,
	skip_confirm_for_simple_edits = false,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 5000,
		autosave_changes = false,
	},
	constrain_cursor = "editable",
	watch_for_changes = true,
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = false,
		["<C-t>"] = false,
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
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
	use_default_keymaps = true,
	view_options = {
		show_hidden = true,
		is_hidden_file = function(name, bufnr)
			local m = name:match("^%.")
			return m ~= nil
		end,
		is_always_hidden = function(name, bufnr)
			return false
		end,
		natural_order = "fast",
		case_insensitive = false,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	extra_scp_args = {},
	extra_s3_args = {},
	git = {
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
	float = {
		padding = 2,
		max_width = 0,
		max_height = 0,
		border = nil,
		win_options = {
			winblend = 0,
		},
		get_win_title = nil,
		preview_split = "auto",
		override = function(conf)
			return conf
		end,
	},
	preview_win = {
		update_on_cursor_moved = true,
		preview_method = "fast_scratch",
		disable_preview = function(filename)
			return false
		end,
		win_options = {},
	},
	confirmation = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = 0.9,
		min_height = { 5, 0.1 },
		height = nil,
		border = nil,
		win_options = {
			winblend = 0,
		},
	},
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
	ssh = {
		border = nil,
	},
	keymaps_help = {
		border = nil,
	},
})

require("snacks").setup({
	---@type snacks.Config
	lazygit = {},
	input = {
		enabled = true,
		win = {
			relative = "cursor", -- Anchor window to cursor
			row = 1, -- Appears exactly one line below
			col = 0,
			width = 40, -- Popup width
			border = "rounded", -- Rounded borders
			title_pos = "left", -- Title aligned to left
			backdrop = false, -- Disable background dimming
		},
	},
	picker = {
		layout = {
			-- preset = "ivy",
		},
		sources = {
			files = { hidden = true, ignored = false },
			grep = { hidden = true, ignored = false },
		},
		formatters = {
			file = {
				-- filename_first = true,
				-- filename_only = true,
			},
		},
	},
	terminal = {},
})

-- ============================================================================
-- 8. TREESITTER OBJECTS
-- ============================================================================

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
		},
		include_surrounding_whitespace = false,
	},
})

-- ============================================================================
-- 9. DEBUGGING (DAP) SETUP
-- ============================================================================

require("mason-nvim-dap").setup({
	automatic_installation = true,
	ensure_installed = { "codelldb" }, -- For C/C++/Rust since you use clangd. Add "debugpy" for Python, "delve" for Go, etc.
	handlers = {}, -- Essential: without this, automatic installation won't configure dap adapters
})

local dap = require("dap")
local dapview = require("dap-view").setup({
	winbar = {
		controls = {
			enabled = true,
			position = "below",
		},
	},
	windows = {
		size = 0.5,
		position = "right",
		terminal = {
			size = 0.5,
			position = "below",
			-- List of debug adapters for which the terminal should be ALWAYS hidden
			-- Can also be set to "true" to never show the terminal
			hide = {},
		},
	},
})

-- Automatically open/close DAP UI when a debug session starts/ends
dap.listeners.before.attach.daui_config = function()
	vim.cmd("only")
	vim.cmd("DapViewOpen")
end
dap.listeners.before.launch.dapui_config = function()
	vim.cmd("only")
	vim.cmd("DapViewOpen")
end
dap.listeners.before.event_terminated.dapui_config = function()
	vim.cmd("DapViewClose")
end
dap.listeners.before.event_exited.dapui_config = function()
	vim.cmd("DapViewClose")
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

-- ============================================================================
-- 10. TASK RUNNER & COMMAND PALETTE
-- ============================================================================

require("overseer").setup({
	-- Automatically open output in a vertical split on the right when a task starts
	component_aliases = {
		default = {
			{ "open_output", direction = "vertical", on_start = "always" },
		},
	},

	-- Manual output opening from the task list sidebar (OverseerToggle)
	task_list = {
		direction = "right", -- Position Overseer sidebar on the right
		bindings = {
			["<CR>"] = "open_vsplit", -- Pressing Enter opens output in vertical split
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
				description = "Neovim command: " .. cmd_name,
			})
		end

		return legendary_cmds
	end,
})

-- ============================================================================
-- 11. FORMATTING & LINTING
-- ============================================================================
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("NullLsRefresh", {})
local helpers = require("null-ls.helpers")
local jnproc_k = ""
local jnproc_v = ""

if 0 ~= nproc then
	jnproc_k = "-j"
	jnproc_v = tostring(nproc - 1)
end

local clangtidy = {
	name = "clangtidy",
	method = {
		null_ls.methods.DIAGNOSTICS_ON_SAVE,
		null_ls.methods.DIAGNOSTICS_ON_OPEN,
		null_ls.methods.DIAGNOSTICS,
	},
	filetypes = { "c", "cpp" },
	generator = helpers.generator_factory({
		command = "run-clang-tidy",
		args = function(params)
			local args = { jnproc_k, jnproc_v, "-checks=clang-analyzer-*" }

			local cc_json = vim.fs.find("compile_commands.json", {
				upward = true,
				path = vim.fs.dirname(params.bufname),
			})[1]

			if cc_json then
				vim.list_extend(args, { "-p", vim.fs.dirname(cc_json) })
			end

			vim.list_extend(args, { "$FILENAME" })
			return args
		end,
		to_stdin = false,
		to_temp_file = false,
		from_stderr = false,
		format = "line",
		check_exit_code = function(code)
			return code <= 1 -- clang-tidy ritorna 1 se trova warning/error, non è un fallimento
		end,
		on_output = function(line, params)
			-- formato: /path/file.c:5:6: warning: messaggio [check-name]
			local row, col, severity, message, code_id = line:match("^.-:(%d+):(%d+): (%a+): (.-) %[([%w%.%-]+)%]$")

			if not row then
				return nil -- salta le righe "note:" (nessun [check-name])
			end

			local severity_map = {
				error = vim.diagnostic.severity.ERROR,
				warning = vim.diagnostic.severity.WARN,
			}

			return {
				row = tonumber(row),
				col = tonumber(col),
				source = "clang-tidy",
				message = message,
				code = code_id,
				severity = severity_map[severity] or vim.diagnostic.severity.WARN,
			}
		end,
	}),
}

null_ls.setup({
	debug = true,
	sources = {
		clangtidy,
		null_ls.builtins.diagnostics.cppcheck.with({
			args = {
				jnproc_k,
				jnproc_v,
				"--enable=warning,style,performance,portability",
				"--template=gcc",
				"--project=compile_commands.json",
				-- "$FILENAME",
			},
			method = {
				null_ls.methods.DIAGNOSTICS_ON_SAVE,
				null_ls.methods.DIAGNOSTICS_ON_OPEN,
				null_ls.methods.DIAGNOSTICS,
			},
			to_temp_file = false,
		}),
	},

	on_attach = function(client, bufnr)
		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})

require("conform").setup({
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- local clang_tidy = require("lint.linters.clangtidy")
-- local cppcheck = require("lint.linters.cppcheck")

-- https://clang.llvm.org/extra/clang-tidy/
-- vim.list_extend(clang_tidy.args, {
-- "--clang-analyzer-*",
-- "--checks=*" -- abseil, altera, android, boost, bugprone,
-- 	-- cert, clang, concurrency, cppcoreguidelines, darwin,
-- 	-- fuchsia, google, hicpp, linuxkernel, llvm, llvmlibc,
-- 	-- misc, modernize, mpi, objc, openmp, performance,
-- 	-- portability, readability, zircon
-- 	.. ",-darwin-*"
-- 	.. ",-linuxkernel-*"
-- 	.. ",-llvmlibc-*"
-- 	.. ",-objc-*"
-- 	.. ",-altera-unroll-loops"
-- 	.. ",-bugprone-easily-swappable-parameters"
-- 	.. ",-fuchsia-default-arguments-calls"
-- 	.. ",-fuchsia-default-arguments-declarations"
-- 	.. ",-fuchsia-overloaded-operator"
-- 	.. ",-fuchsia-trailing-return"
-- 	.. ",-google-explicit-constructor"
-- 	.. ",-hicpp-explicit-conversions"
-- 	.. ",-llvm-else-after-return"
-- 	.. ",-llvm-header-guard"
-- 	.. ",-misc-non-private-member-variables-in-classes"
-- 	.. ",-misc-use-anonymous-namespace"
-- 	.. ",-modernize-use-trailing-return-type"
-- 	.. ",-readability-else-after-return"
-- 	.. ",-readability-function-cognitive-complexity"
-- 	.. ",-readability-identifier-length"
-- 	.. ",-readability-isolate-declaration"
-- 	.. ",-readability-magic-numbers"
-- 	.. ",-readability-redundant-access-specifiers"
-- 	.. ",-readability-redundant-inline-specifier"
-- 	.. ",-readability-simplify-boolean-expr",

-- .. ",-cppcoreguidelines-avoid-do-while"
-- .. ",-cppcoreguidelines-avoid-magic-numbers"
-- .. ",-cppcoreguidelines-non-private-member-variables-in-classes"
-- .. ",-cppcoreguidelines-owning-memory"
-- .. ",-cppcoreguidelines-rvalue-reference-param-not-moved"
-- .. ",-modernize-use-nodiscard"
-- })

-- require("lint").linters_by_ft = {
-- 	c = { "clangtidy" },
-- 	cpp = { "clangtidy" },
-- 	markdown = { "vale" },
-- }

-- ============================================================================
-- 12. TEXT OBJECTS / EDITING EXTRAS
-- ============================================================================

require("tabout").setup({})
