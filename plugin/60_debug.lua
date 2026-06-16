-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- DAP ================================
later(function()
	add({ "https://github.com/mfussenegger/nvim-dap" })
	local dap = require("dap")

	-- Defaults
	dap.defaults.fallback = {
		switchbuf = "usevisible,usetab,uselast",
	}

	-- Add keymaps for dap
	-- Breakpoints
	Config.nmap_leader("db", require("dap").toggle_breakpoint, "Toggle [B]reakpoint")
	-- New/Continue session
	Config.nmap_leader("ds", require("dap").continue, "[S]tart/Continue")
	-- Disconnect
	Config.nmap_leader("dq", "<cmd>DapTerminate<cr>", "[Q]uit")
	-- Continue
	Config.nmap_leader("dc", "<cmd>DapContinue<cr>", "[C]ontinue")
	-- Debug Commands
	Config.nmap("<Down>", "<cmd>DapStepOver<cr>", "Step Over")
	Config.nmap("<Right>", "<cmd>DapStepInto<cr>", "Step Over")
	Config.nmap("<Left>", "<cmd>DapStepOut<cr>", "Step Over")
	Config.nmap("<Up>", "<cmd>DapRestartFrame<cr>", "Step Over")

	-- GDB (C/C++/Rust)
	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}

	-- LLDB
	dap.adapters.lldb = {
		type = "executable",
		command = vim.fn.exepath("lldb-dap"),
		name = "lldb",
	}

	-- Code lldb
	dap.adapters.codelldb = {
		type = "executable",
		command = "codelldb",
	}

	-- GDB Rust Wrapper (Rust)
	dap.adapters["rust-gdb"] = {
		type = "executable",
		command = "rust-gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}
end)

-- DAP View =============================
later(function()
	add({ "https://github.com/igorlfs/nvim-dap-view" })
	require("dap-view").setup({
		winbar = {
			show = true,
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
			default_section = "scopes",
			controls = { enabled = true },
		},
	})

	-- Toggle View
	Config.nmap_leader("dv", "<cmd>DapViewToggle<cr>", "Toggle DAP [V]iew")
end)

-- DAP Virtual Text =======================
later(function()
	add({"https://github.com/theHamsta/nvim-dap-virtual-text"})
	require("nvim-dap-virtual-text").setup({})

	-- Toggle Virtual Text
	Config.nmap_leader("dt", "<cmd>DapVirtualTextToggle<cr>", "[T]oggle Virtual Text")
end)

-- Language Specific Plugins ===========================================
-- Go =========================
later(function()
	add({ "https://github.com/leoluz/nvim-dap-go" })
	require("dap-go").setup()
end)
-- Python ======================
later(function()
	add({ "https://github.com/mfussenegger/nvim-dap-python" })
	require("dap-python").setup("uv")
end)
