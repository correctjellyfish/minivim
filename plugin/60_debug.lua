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
	-- Debug Commands
	Config.nmap("<Down>", "<cmd>DapStepOver<cr>", "Step Over")
	Config.nmap("<Right>", "<cmd>DapStepInto<cr>", "Step Over")
	Config.nmap("<Left>", "<cmd>DapStepOut<cr>", "Step Over")
	Config.nmap("<Up>", "<cmd>DapRestartFrame<cr>", "Step Over")

	-- Setup Adapters
	local dap = require("dap")
	-- GDB (C/C++/Rust)
	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}
	-- GDB Rust Wrapper (Rust)
	dap.adapters["rust-gdb"] = {
		type = "executable",
		command = "rust-gdb",
		args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
	}

	-- Configuration for C/C++
	dap.configurations.c = {
		{
			name = "Launch",
			type = "gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = {}, -- provide arguments if needed
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = false,
		},
		{
			name = "Select and attach to process",
			type = "gdb",
			request = "attach",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			pid = function()
				local name = vim.fn.input("Executable name (filter): ")
				return require("dap.utils").pick_process({ filter = name })
			end,
			cwd = "${workspaceFolder}",
		},
		{
			name = "Attach to gdbserver :1234",
			type = "gdb",
			request = "attach",
			target = "localhost:1234",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
	}
	dap.configurations.cpp = dap.configurations.c
	-- Configuration for Rust
	dap.configurations.rust = {
		{
			name = "Launch",
			type = "rust-gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = {}, -- provide arguments if needed
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = false,
		},
		{
			name = "Select and attach to process",
			type = "rust-gdb",
			request = "attach",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			pid = function()
				local name = vim.fn.input("Executable name (filter): ")
				return require("dap.utils").pick_process({ filter = name })
			end,
			cwd = "${workspaceFolder}",
		},
		{
			name = "Attach to gdbserver :1234",
			type = "rust-gdb",
			request = "attach",
			target = "localhost:1234",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
	}
end)

-- DAP View =============================
later(function()
	add("igorlfs/nvim-dap-view")
	require("dap-view").setup({
		winbar = {
			controls = { enabled = true },
		},
	})

	-- Toggle View
	Config.nmap_leader("dv", "<cmd>DapViewToggle<cr>", "Toggle DAP [V]iew")
end)
