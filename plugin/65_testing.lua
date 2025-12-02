-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Neotest ========================================================
later(function()
	add({
		source = "nvim-neotest/neotest",
		depends = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"orjangj/neotest-ctest", -- C++ test runner (ctest/catch2/etc)
			"nvim-neotest/neotest-python", -- Python test runner
		},
	})

	require("neotest").setup({
		adapters = {
			require("neotest-python")({ runner = "pytest" }), -- Python
			require("rustaceanvim.neotest"), -- Rust
			require("neotest-ctest"), -- C++
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
