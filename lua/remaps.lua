vim.g.mapleader = " "

-- ==============================================================================
-- REMOVE OLD KEYMAPS
-- ==============================================================================
pcall(vim.keymap.del, { "n" }, "grn")
pcall(vim.keymap.del, { "n" }, "grr")
pcall(vim.keymap.del, { "n" }, "gri")
pcall(vim.keymap.del, { "n", "x" }, "gra")
pcall(vim.keymap.del, { "n" }, "grx")
pcall(vim.keymap.del, { "n" }, "grt")
pcall(vim.keymap.del, { "i" }, "<C-s>")

-- ==============================================================================
-- MODULES & FUNCTIONS
-- ==============================================================================
local flash = require("flash")
local picker = require("snacks").picker
local dap, dapui = require("dap"), require("dapui")

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

local function definition_or_references_vsplit()
	local params = vim.lsp.util.make_position_params(0, "utf-16")
	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			-- Se fallisce la definizione o non c'è, apre il picker delle definizioni in vsplit
			picker.lsp_definitions({ jump_type = "vsplit" })
			return
		end

		local items = vim.lsp.util.locations_to_items(result, "utf-16")
		local cur_file = vim.fn.expand("%:p")
		local cur_line = vim.api.nvim_win_get_cursor(0)[1]

		for _, item in ipairs(items) do
			-- Se siamo già sulla definizione, apriamo le references in vsplit
			if vim.fn.fnamemodify(item.filename, ":p") == cur_file and item.lnum == cur_line then
				picker.lsp_references({ jump_type = "vsplit" })
				return
			end
		end

		-- Se c'è una sola definizione diretta, creiamo lo split prima di saltare
		if #items == 1 then
			vim.cmd("vsplit")
			vim.lsp.util.show_document(result[1], "utf-16", { focus = true })
		else
			-- Se ci sono più definizioni, lasciamo gestire al picker in vsplit
			picker.lsp_definitions({ jump_type = "vsplit" })
		end
	end)
end

-- ==============================================================================
-- LEGENDARY.NVIM CONFIGURATION
-- ==============================================================================
require("legendary").keymaps({
	-- System & Windows
	{
		itemgroup = "System & Windows",
		icon = "󰒲",
		keymaps = {
			{
				"m",
				"<CMD>vertical rightb Man<CR>",
				description = "Manpages",
				mode = "n",
			},
			{
				"-",
				"<CMD>Oil<CR>",
				description = "Open parent directory (Oil)",
				mode = "n",
			},
			{
				"<leader><leader>",
				":so<cr>",
				description = "Reload configuration (Source file)",
				mode = "n",
			},
			{
				"<Esc>",
				"<cmd>nohlsearch<CR>",
				description = "Clear search highlight",
				mode = "n",
			},
			{
				"<C-BS>",
				"<C-w>",
				description = "Delete previous word",
				mode = { "i", "c" },
			},
			{
				"<C-Backspace>",
				"<C-w>",
				description = "Delete previous word",
				mode = { "i", "c" },
			},
			{
				"<C-d>",
				"<C-d>zz",
				description = "Scroll down and center",
				mode = "n",
			},
			{
				"<C-u>",
				"<C-u>zz",
				description = "Scroll up and center",
				mode = "n",
			},
			{
				"<C-h>",
				"<C-w>h",
				description = "Move to left window",
				mode = "n",
			},
			{
				"<C-j>",
				"<C-w>j",
				description = "Move to bottom window",
				mode = "n",
			},
			{
				"<C-k>",
				"<C-w>k",
				description = "Move to top window",
				mode = "n",
			},
			{
				"<C-l>",
				"<C-w>l",
				description = "Move to right window",
				mode = "n",
			},
		},
	},

	-- Flash Navigation
	{
		itemgroup = "Navigation (Flash)",
		icon = "⚡",
		keymaps = {
			{ "r", flash.jump, description = "Flash: Jump to word", mode = { "n", "x" } },
		},
	},

	-- Snacks Terminal
	{
		itemgroup = "Terminal",
		icon = "",
		keymaps = {
			{
				"<C-t>",
				function()
					Snacks.terminal.toggle(
						nil,
						{ win = { position = "right", border = "rounded", width = 0.5, height = 0.8 } }
					)
				end,
				description = "Toggle Terminal",
				mode = { "n", "t" },
			},
			{
				"<C-o>",
				"<C-\\><C-n>",
				description = "Enter Normal Mode from terminal",
				mode = "t",
			},
			{
				"<C-w>q",
				"<cmd>wincmd q<cr>",
				description = "Close terminal window",
				mode = "t",
			},
			{
				"<C-h>",
				"<cmd>wincmd h<cr>",
				description = "Move to left window (Terminal)",
				mode = "t",
			},
			{
				"<C-j>",
				"<cmd>wincmd j<cr>",
				description = "Move to bottom window (Terminal)",
				mode = "t",
			},
			{
				"<C-k>",
				"<cmd>wincmd k<cr>",
				description = "Move to top window (Terminal)",
				mode = "t",
			},
			{
				"<C-l>",
				"<cmd>wincmd l<cr>",
				description = "Move to right window (Terminal)",
				mode = "t",
			},
		},
	},

	-- Git (Snacks & Picker)
	{
		itemgroup = "Git",
		icon = "󰊢",
		keymaps = {
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				description = "Toggle LazyGit",
				mode = "n",
			},
			{
				"<leader>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				description = "Current file history (LazyGit)",
				mode = "n",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				description = "Commit log (LazyGit)",
				mode = "n",
			},
			{
				"<leader>gc",
				picker.git_log,
				description = "Git commits",
				mode = "n",
			},
			{
				"<leader>gb",
				picker.git_branches,
				description = "Git branches",
				mode = "n",
			},
		},
	},

	-- Search & Pickers
	{
		itemgroup = "Search & Pickers",
		icon = "",
		keymaps = {
			{
				"<leader>pf",
				picker.files,
				description = "Pick file",
				mode = "n",
			},

			{ "<leader>pt", "<CMD>OverseerRun<CR>", description = "Pick task", mode = "n" },
			{
				"<leader>pw",
				function()
					picker.grep({ need_search = false, live = false })
				end,
				description = "Pick word (Grep)",
				mode = "n",
			},
			{
				"<leader>pp",
				picker.projects,
				description = "Pick projects",
				mode = "n",
			},
			{
				"<leader>ph",
				picker.help,
				description = "Help tags",
				mode = "n",
			},
			{
				"<leader>pk",
				picker.keymaps,
				description = "Search keymaps",
				mode = "n",
			},
			{
				"<leader>pC",
				picker.colorschemes,
				description = "Search colorschemes",
				mode = "n",
			},

			-- HERE IS THE INTEGRATION FOR <leader>pc
			{
				"<leader>pc",
				require("legendary").find,
				description = "Open Command Palette (Legendary)",
				mode = "n",
			},
		},
	},

	-- LSP & Diagnostics
	{
		itemgroup = "LSP",
		icon = "󰒋",
		keymaps = {
			{
				"<C-w>gd",
				definition_or_references_vsplit,
				description = "Go to definition (or references) in vsplit",
				mode = "n",
			},
			{
				"gd",
				definition_or_references,
				description = "Go to definition (or references)",
				mode = "n",
			},
			{
				"gr",
				picker.lsp_references,
				description = "Go to references",
				mode = "n",
			},
			{
				"<leader>ca",
				vim.lsp.buf.code_action,
				description = "Code action",
				mode = { "n", "v" },
			},
			{
				"<leader>cr",
				vim.lsp.buf.rename,
				description = "Rename symbol",
				mode = "n",
			},
			{
				"<C-s>",
				function()
					local blink = require("blink.cmp")

					-- se è già aperto, il tasto lo chiude (toggle)
					if blink.is_signature_visible() then
						blink.hide_signature()
						return
					end

					if not blink.show_signature() then
						return
					end

					-- blink.cmp aggiorna il popup (posizione + contenuto) da solo solo sui
					-- movimenti del cursore in insert mode. In normal mode nessuno lo
					-- richiama più dopo il primo show, quindi resta fermo dov'era comparso.
					-- Lo teniamo sincronizzato a mano finché resta aperto.
					-- show_signature() pubblico non rifà nulla se è già visibile, quindi
					-- serve richiamare direttamente il modulo interno (non documentato
					-- pubblicamente, occhio se aggiorni blink.cmp) che usa anche lui.
					local group = vim.api.nvim_create_augroup("ManualSignatureFollow", { clear = true })

					local function cleanup()
						pcall(vim.api.nvim_del_augroup_by_id, group)
					end

					vim.api.nvim_create_autocmd("CursorMoved", {
						group = group,
						callback = function()
							if not blink.is_signature_visible() then
								cleanup()
								return
							end
							require("blink.cmp.signature.trigger").show({ force = true })
						end,
					})

					-- smetti di seguirlo se entri in insert, cambi buffer, o lo chiudi a mano
					vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
						group = group,
						once = true,
						callback = cleanup,
					})
				end,
				description = "LSP Signature Help (toggle, segue il cursore)",
				mode = "n",
			},
			{
				"<leader>k",
				vim.diagnostic.open_float,
				description = "Show diagnostic",
				mode = "n",
			},
			{
				"<leader>ps",
				picker.lsp_symbols,
				description = "Pick document symbols",
				mode = "n",
			},
			{
				"<leader>po",
				function()
					picker.lsp_workspace_symbols({ search = "" })
				end,
				description = "Pick workspace symbols",
				mode = "n",
			},
			{
				"<leader>up",
				picker.diagnostics,
				description = "Workspace diagnostics",
				mode = "n",
			},
		},
	},

	-- Debug (DAP)
	{
		itemgroup = "Debug (DAP)",
		icon = "",
		keymaps = {
			{ "<F5>", dap.continue, description = "Debug: Avvia/Continua", mode = "n" },
			{ "<S-F5>", dap.run_last, description = "Debug: Ripeti ultima sessione", mode = "n" },
			{ "<F10>", dap.step_over, description = "Debug: Step over", mode = "n" },
			{ "<F11>", dap.step_into, description = "Debug: Step into", mode = "n" },
			{ "<F12>", dap.step_out, description = "Debug: Step out", mode = "n" },
			{
				"<leader>do",
				"<cmd>OverseerToggle<cr>",
				description = "Debug: Mostra output build (Overseer)",
				mode = "n",
			},

			{
				"<leader>ds",
				function()
					local session = dap.session()
					if not session then
						vim.notify("Nessuna sessione di debug attiva", vim.log.levels.WARN)
						return
					end

					local function do_terminate()
						-- terminate() è corretto per sessioni "launch" (es. codelldb):
						-- uccide anche il processo debuggato, cosa che disconnect() non fa di default.
						-- IMPORTANTE: terminate() vuole UNA tabella di opzioni, non 3 argomenti
						-- posizionali: il callback va passato come opts.on_done, altrimenti internamente
						-- 'cb' risulta una tabella invece di una funzione -> crash
						-- ("attempt to call upvalue 'cb' (a table value)").
						-- dapui.close() viene chiamato SOLO in on_done, dopo che la sessione è
						-- davvero terminata, per non entrare in corsa con i listener
						-- event_terminated/event_exited già definiti in plugins.lua (che altrimenti
						-- chiamano dapui.close() una seconda volta mentre ci sono ancora richieste
						-- in sospeso verso l'adapter -> crash).
						dap.terminate({
							on_done = function()
								dapui.close()
							end,
						})
					end

					-- Se il debuggee è ancora "in corsa" (es. uno step_over/into/out è stato
					-- lanciato e non è ancora arrivato l'evento "stopped"), stopped_thread_id
					-- è nil. Mandare terminate() in quel momento fa collidere la risposta/evento
					-- dello step in volo con la sessione che viene smontata: su Windows con
					-- codelldb questo può far crashare l'adapter (e trascinarsi dietro Neovim)
					-- invece di dare un errore Lua gestibile. Aspettiamo che si fermi davvero.
					if not session.stopped_thread_id then
						vim.notify("Attendo che lo step finisca prima di fermare...", vim.log.levels.INFO)
						local attempts = 0
						local timer = vim.uv.new_timer()
						timer:start(
							50,
							50,
							vim.schedule_wrap(function()
								attempts = attempts + 1
								local s = dap.session()
								if not s then
									timer:stop()
									timer:close()
									return
								end
								if s.stopped_thread_id or attempts >= 40 then -- max ~2s di attesa
									timer:stop()
									timer:close()
									do_terminate()
								end
							end)
						)
						return
					end

					do_terminate()
				end,
				description = "Debug: Stop (termina sessione e processo)",
				mode = "n",
			},
			{ "<leader>dr", dap.restart, description = "Debug: Riavvia sessione", mode = "n" },

			{ "<leader>db", dap.toggle_breakpoint, description = "Debug: Toggle breakpoint", mode = "n" },
			{
				"<leader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Condizione breakpoint: "))
				end,
				description = "Debug: Breakpoint condizionale",
				mode = "n",
			},
			{
				"<leader>dL",
				function()
					dap.set_breakpoint(nil, nil, vim.fn.input("Messaggio log point: "))
				end,
				description = "Debug: Log point",
				mode = "n",
			},
			{
				"<leader>dc",
				dap.clear_breakpoints,
				description = "Debug: Pulisci tutti i breakpoint",
				mode = "n",
			},

			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				description = "Debug: Ispeziona variabile sotto il cursore",
				mode = { "n", "v" },
			},
			{
				"<leader>dR",
				function()
					dap.repl.toggle()
				end,
				description = "Debug: Toggle REPL",
				mode = "n",
			},
			{
				"<leader>du",
				dapui.toggle,
				description = "Debug: Toggle UI",
				mode = "n",
			},

			{
				"<leader>dn",
				"<cmd>DapCreateLaunchJson<cr>",
				description = "Debug: Crea launch.json di default",
				mode = "n",
			},
		},
	},

	-- Treesitter Textobjects: Selections
	{
		itemgroup = "Treesitter (Selections)",
		icon = "󰔱",
		keymaps = {
			{
				"af",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
				end,
				description = "Select around function",
				mode = { "x", "o" },
			},
			{
				"if",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
				end,
				description = "Select inner function",
				mode = { "x", "o" },
			},
			{
				"ac",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
				end,
				description = "Select around class",
				mode = { "x", "o" },
			},
			{
				"ic",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
				end,
				description = "Select inner class",
				mode = { "x", "o" },
			},
			{
				"as",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
				end,
				description = "Select local scope",
				mode = { "x", "o" },
			},
		},
	},

	-- Treesitter Textobjects: Navigation
	{
		itemgroup = "Treesitter (Navigation)",
		icon = "󰔱",
		keymaps = {
			{
				"<leader>a",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end,
				description = "Swap with next parameter",
				mode = "n",
			},
			{
				"<leader>A",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
				end,
				description = "Swap with previous parameter",
				mode = "n",
			},

			{
				"]m",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
				description = "Go to next function start",
				mode = { "n", "x", "o" },
			},
			{
				"]]",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
				end,
				description = "Go to next class start",
				mode = { "n", "x", "o" },
			},
			{
				"]o",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						{ "@loop.inner", "@loop.outer" },
						"textobjects"
					)
				end,
				description = "Go to next loop start",
				mode = { "n", "x", "o" },
			},
			{
				"]s",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
				end,
				description = "Go to next local scope",
				mode = { "n", "x", "o" },
			},
			{
				"]z",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
				end,
				description = "Go to next fold",
				mode = { "n", "x", "o" },
			},
			{
				"]M",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
				end,
				description = "Go to next function end",
				mode = { "n", "x", "o" },
			},
			{
				"][",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
				end,
				description = "Go to next class end",
				mode = { "n", "x", "o" },
			},
			{
				"]i",
				function()
					require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
				end,
				description = "Go to next conditional",
				mode = { "n", "x", "o" },
			},

			{
				"[m",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
				description = "Go to previous function start",
				mode = { "n", "x", "o" },
			},
			{
				"[[",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
				end,
				description = "Go to previous class start",
				mode = { "n", "x", "o" },
			},
			{
				"[M",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end,
				description = "Go to previous function end",
				mode = { "n", "x", "o" },
			},
			{
				"[]",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
				end,
				description = "Go to previous class end",
				mode = { "n", "x", "o" },
			},
			{
				"[i",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
				end,
				description = "Go to previous conditional",
				mode = { "n", "x", "o" },
			},
		},
	},
})
