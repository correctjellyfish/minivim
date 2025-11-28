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
	-- Disconnect
	Config.nmap_leader("dq", "<cmd>DapTerminate<cr>", "[Q]uit")
	-- Continue
	Config.nmap_leader("dc", "<cmd>DapContinue<cr>", "[C]ontinue")
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
	-- LLDB-DAP
	dap.adapters.lldb = {
		type = "executable",
		command = vim.fn.expand("$HOME") .. "/.pixi/bin/lldb-dap",
		name = "lldb",
	}

	-- Debugpy (Python)
	dap.adapters.python = function(cb, config)
		if config.request == "attach" then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
			local host = (config.connect or config).host or "127.0.0.1"
			cb({
				type = "server",
				port = assert(port, "`connect.port` is required for a python `attach` configuration"),
				host = host,
				options = {
					source_filetype = "python",
				},
			})
		else
			cb({
				type = "executable",
				command = "$HOME/.local/bin/debugpy", -- Installed with uv
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			})
		end
	end

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
			stopAtBeginningOfMainSubprogram = true,
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
	-- Python configuration
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable("$VIRTUAL_ENV/bin/python") == 1 then
					return "$VIRTUAL_ENV/bin/python"
				elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					local python_exe = vim.fn.systemlist("which python")[1]
					if vim.v.shell_error ~= 0 then
						return "/usr/bin/python"
					else
						return python_exe
					end
				end
			end,
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

-- DAP Virtual Text =======================
later(function()
	add({ source = "theHamsta/nvim-dap-virtual-text", depends = { "mfussenegger/nvim-dap" } })
	require("nvim-dap-virtual-text").setup()

	-- Toggle Virtual Text
	Config.nmap_leader("dt", "<cmd>DapVirtualTextToggle<cr>", "[T]oggle Virtual Text")
end)

-- Language Specific Plugins ===========================================
later(function()
	add({ source = "leoluz/nvim-dap-go", depends = { "mfussenegger/nvim-dap" } })
	require("dap-go").setup()
end)
