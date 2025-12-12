-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Marks ======================================================================
later(function()
	add("chentoast/marks.nvim")
	require("marks").setup()
end)

-- Yanky ======================================================================
later(function()
	add("gbprod/yanky.nvim")
	require("yanky").setup({
		highlight = { timer = 150 },
		preserve_cursor_position = {
			enabled = true,
		},
	})
	vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank text" })
	vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after cursor" })
	vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before cursor" })
	vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after selection" })
	vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before selection" })

	vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous yank from history" })
	vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next Yank from history" })
end)

-- REPL/Slime ================================================================
later(function()
	add("jpalardy/vim-slime")
	-- Configure with the global values
	vim.g.slime_target = "tmux"
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_default_config = {
		socket_name = vim.fn.split(vim.env.TMUX, ",")[1],
		target_pane = ":.2",
	}
	Config.nmap("gz", "<Plug>SlimeMotionSend", "Slime Motion Send")
	Config.nmap("gzz", "<Plug>SlimeLineSend", "Slime Motion Send")
	Config.xmap("gz", "<Plug>SlimeRegionSend", "Slime Region Send")
	Config.nmap("gzc", "<Plug>SlimeConfig", "Slime Config")
end)

later(function()
	add("Vigemus/iron.nvim")

	local iron = require("iron.core")
	local marks = require("iron.marks")
	local view = require("iron.view")
	local common = require("iron.fts.common")

	iron.setup({
		config = {
			scratch_repl = true,
			repl_definition = {
				python = {
					command = { "python" },
					format = common.bracketed_paste_python,
					block_dividers = { "# %%", "#%%" },
					env = { PYTHON_BASIC_REPL = "1" },
				},
				ocaml = {
					command = function()
						-- Check if in dune project
						vim.fn.systemlist("dune describe")
						if vim.v.shell_error ~= 0 then
							-- Not in a dune project, just use regular utop
							return { "utop" }
						end
						return { "dune", "utop" }
					end,
					format = function(lines)
						lines[#lines] = lines[#lines] .. ";;" .. string.char(13)
						return lines
					end,
				},
				r = {
					command = { "R" },
					format = common.bracketed_paste,
				},
				quarto = {
					command = { "R" },
					format = common.bracketed_paste,
				},
			},
			repl_filetype = function(_, ft)
				return ft
			end,
			repl_open_cmd = view.split.vertical.botright(80),
		},
		keymaps = {},
		highlight = { italic = true },
		ignore_blank_lines = true,
	})

	-- Leader keymaps
	-- REPL Commands
	Config.nmap_leader("rr", "<cmd>IronRepl<cr>", "Toggle")
	Config.nmap_leader("rR", "<cmd>IronRestart<cr>", "Restart")
	Config.nmap_leader("rf", "<cmd>IronFocus<cr>", "Focus")
	Config.nmap_leader("rq", iron.close_repl, "Close")
	Config.nmap_leader("rh", iron.hide_repl, "Hide")
	Config.nmap_leader("rc", function()
		iron.send(nil, string.char(12))
	end, "Clear")
	Config.nmap_leader("rx", function()
		iron.send(nil, string.char(03))
	end, "Interrupt")

	-- Send Commands
	Config.nmap_leader("rl", iron.send_line, "Send Line")
	Config.nmap_leader("rF", iron.send_file, "Send File")
	Config.nmap_leader("rp", iron.send_paragraph, "Send Paragraph")
	Config.nmap_leader("rp", iron.send_until_cursor, "Send Until Cursor")
	Config.nmap_leader("rm", iron.send_mark, "Send Mark")
	Config.nmap_leader("rb", function()
		iron.send_code_block(false)
	end, "Send Block")
	Config.nmap_leader("rB", function()
		iron.send_code_block(true)
	end, "Send Block and Move")
	Config.nmap_leader("rz", function()
		require("iron.core").run_motion("send_motion")
	end, "Send Motion")
	Config.nmap_leader("re", function()
		iron.send(nil, string.char(13))
	end, "Send Enter")

	-- Mark
	Config.nmap_leader("rd", marks.drop_last, "Delete Mark")
	Config.nmap_leader("ro", function()
		require("iron.core").run_motion("mark_motion")
	end, "Mark Motion")

	-- Additional keymaps
	-- Visual Mode
	-- Send
	vim.keymap.set("v", "<leader>rs", iron.visual_send, { desc = "Send Selection" })
	-- Mark
	vim.keymap.set("v", "<leader>rm", iron.mark_visual, { desc = "Mark Selection" })
end)

-- Tmux =======================================================================
later(function()
	vim.g.tmux_navigator_no_mappings = 1
	add("christoomey/vim-tmux-navigator")
	Config.nmap("<c-h>", "<cmd>TmuxNavigateLeft<cr>")
	Config.nmap("<c-j>", "<cmd>TmuxNavigateDown<cr>")
	Config.nmap("<c-k>", "<cmd>TmuxNavigateUp<cr>")
	Config.nmap("<c-l>", "<cmd>TmuxNavigateRight<cr>")
end)

-- Todo Comments =======================================================
later(function()
	add({ source = "folke/todo-comments.nvim", depends = { "nvim-lua/plenary.nvim" } })
	require("todo-comments").setup({})
	_G.Config.nmap_leader("ft", "<cmd>TodoQuickFix<cr>", "Todo QuickFix")
end)

-- Git ========================================================================
later(function()
	add("lewis6991/gitsigns.nvim")
	require("gitsigns").setup({
		-- See `:help gitsigns.txt`
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
	vim.cmd([[hi GitSignsAdd guifg=#04de21]])
	vim.cmd([[hi GitSignsChange guifg=#83fce6]])
	vim.cmd([[hi GitSignsDelete guifg=#fa2525]])

	-- Diff view
	add("sindrets/diffview.nvim")
	require("diffview").setup({})
	Config.nmap_leader("gv", "<cmd>DiffViewOpen<cr>", "Diff view")

	-- Neogit
	add({
		source = "NeogitOrg/neogit",
		depends = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
	})

	-- Keymap to open neogit
	_G.Config.nmap_leader("gn", "<cmd>Neogit<cr>", "Open Neogit")
end)

-- Incremental Rename ======================================================
later(function()
	add("smjonas/inc-rename.nvim")
	require("inc_rename").setup({})

	vim.keymap.set("n", "<leader>lr", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true, desc = "Rename" })
end)

-- Task Runner =============================================================
later(function()
	add("stevearc/overseer.nvim")
	require("overseer").setup()

	Config.nmap_leader("Tr", "<cmd>OverseerRun<cr>", "Run")
	Config.nmap_leader("Ta", "<cmd>OverseerTaskAction<cr>", "Action")
	Config.nmap_leader("Tt", "<cmd>OverseerToggle<cr>", "Toggle")
end)
