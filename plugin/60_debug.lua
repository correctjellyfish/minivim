-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- DAP ================================
later(function()
	add("mfussenegger/nvim-dap")

	-- Add keymaps for dap
	-- Breakpoints
	Config.nmap_leader("db", require("dap").toggle_breakpoint, "Toggle [B]reakpoint")
	-- New/Continue session
	Config.nmap_leader("ds", require("dap").continue, "[S]tart/Continue")

	-- Setup Adapters
end)

-- DAP View =============================
later(function()
	add("igorlfs/nvim-dap-view")
	require("dap-view").setup({
		winbar = {
			controls = { enabled = true },
		},
	})

	-- Open View
	Config.nmap_leader("dv", "<cmd>DapViewOpen<cr>", "Open DAP [V]iew")
	-- Close View
	Config.nmap_leader("dx", "<cmd>DapViewClose<cr>", "Close DAP View")
end)
