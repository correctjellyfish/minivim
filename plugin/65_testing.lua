-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- Neotest ========================================================
later(function()
	add({
		"https://github.com/nvim-neotest/nvim-nio",
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/antoinemadec/FixCursorHold.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/orjangj/neotest-ctest", -- C++ test runner (ctest/catch2/etc)
		"https://github.com/nvim-neotest/neotest-python", -- Python test runner
		"https://github.com/fredrikaverpil/neotest-golang", -- Go test runner
	})
	add({
		"https://github.com/nvim-neotest/neotest",
	})

	require("neotest").setup({
		adapters = {
			require("neotest-python")({ runner = "pytest" }), -- Python
			require("rustaceanvim.neotest"), -- Rust
			require("neotest-ctest"), -- C++
			require("neotest-golang"), -- Go
		},
	})

	local neotest = require("neotest")
	Config.nmap_leader("nn", neotest.run.run, "Test Nearest")
	Config.nmap_leader("ns", neotest.run.stop, "Stop Nearest Test")
	Config.nmap_leader("na", neotest.run.attach, "Attach Nearest Test")
	Config.nmap_leader("nd", ":lua require('neotest').run.run({strategy='dap'})<cr>", "Debug Nearest Test")
	Config.nmap_leader("nf", ":lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Test File")
	Config.nmap_leader("nw", ":lua require('neotest').watch.watch(vim.fn.expand('%'))<cr>", "Watch File")
	Config.nmap_leader("no", ":lua require('neotest').output_panel.toggle()<cr>", "Toggle Test Ouput")
end)
