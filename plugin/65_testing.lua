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
			require("neotest-python"), -- Python
			require("rustaceanvim.neotest"), -- Rust
			require("neotest-ctest"), -- C++
		},
	})
end)
