-- Make concise helpers for installing/adding plugins in two stages
local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now
local now_if_args = _G.Config.now_if_args

-- Terminal ==============================================================
later(function()
	add("akinsho/toggleterm.nvim")
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shell = "fish",
	})
	-- Keymaps
	_G.Config.nmap(
		"<leader>tr",
		"<cmd>TermNew size=40 dir=git_dir direction=float name=root-terminal<cr>",
		"Open [T]erminal [R]oot Directory"
	)
	_G.Config.nmap(
		"<leader>tc",
		"<cmd>TermNew size=40 dir=. direction=float name=cwd-terminal<cr>",
		"Open [T]erminal [C]urrent [W]orking [D]irectory"
	)
	_G.Config.nmap(
		"<leader>tb",
		"<cmd>TermNew size=20 dir=. direction=horizontal name=horizontal-terminal<cr>",
		"Open [B]ottom Terminal"
	)
	_G.Config.nmap("<leader>ts", "<cmd>TermSelect<cr>", "[S]elect Terminal")
end)

-- Neotree =============================================================
later(function()
	local function copy_path(state)
		-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
		-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
		local node = state.tree:get_node()
		local filepath = node:get_id()
		local filename = node.name
		local modify = vim.fn.fnamemodify

		local results = {
			filepath,
			modify(filepath, ":."),
			modify(filepath, ":~"),
			filename,
			modify(filename, ":r"),
			modify(filename, ":e"),
		}

		vim.ui.select({
			"1. Absolute path: " .. results[1],
			"2. Path relative to CWD: " .. results[2],
			"3. Path relative to HOME: " .. results[3],
			"4. Filename: " .. results[4],
			"5. Filename without extension: " .. results[5],
			"6. Extension of the filename: " .. results[6],
		}, { prompt = "Choose to copy to clipboard:" }, function(choice)
			if choice then
				local i = tonumber(choice:sub(1, 1))
				if i then
					local result = results[i]
					vim.fn.setreg('"', result)
					vim.notify("Copied: " .. result)
				else
					vim.notify("Invalid selection")
				end
			else
				vim.notify("Selection cancelled")
			end
		end)
	end

	add({
		source = "nvim-neo-tree/neo-tree.nvim",
		checkout = "v3.x",
		depends = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
	})

	require("neo-tree").setup({
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
					["Y"] = copy_path,
				},
			},
		},
	})
	_G.Config.nmap_leader("et", "<cmd>Neotree reveal<cr>", "Tree")
	_G.Config.nmap("\\\\", "<cmd>Neotree reveal<cr>", "Tree")
end)

-- Zen ===============================================================
-- Currently set up for writing
later(function()
	add("folke/zen-mode.nvim")
	require("zen-mode").setup({
		window = {
			backdrop = 0,
			width = 0.7,
			height = 1,
			options = {
				signcolumn = "no",
				number = false,
				relativenumber = false,
				cursorline = false,
				cursorcolumn = false,
				foldcolumn = "0",
				list = false,
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0,
				},
				gitsigns = { enabled = false },
				tmux = { enabled = true },
			},
		},
		on_open = function()
			-- Modify colorscheme
			vim.cmd("colorscheme " .. _G.Config.focus_colorscheme)
			-- Disable mini modules
			vim.g.mininotify_disable = true
			vim.g.minicursorword_disable = true
			vim.g.minicompletion_disable = true
			-- Disable fidget polling
			require("fidget").setup({
				progress = {
					suppress_on_insert = true,
				},
				display = { render_limit = 0 },
			})
			-- Disable virtual text and lines
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
		end,
		on_close = function()
			-- Undo on_open function
			vim.cmd("colorscheme " .. _G.Config.colorscheme)
			vim.g.mininotify_disable = false
			vim.g.minicursorword_disable = false
			vim.g.minicompletion_disable = false
			require("fidget").setup({
				progress = {
					suppress_on_insert = false,
				},
				display = { render_limit = 16 },
			})
			vim.diagnostic.config({ virtual_text = true }) -- TODO: Better toggle
		end,
	})

	_G.Config.nmap("\\z", "<cmd>Zen<cr>", "Toggle 'zen'")
end)
