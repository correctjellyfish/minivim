-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Quarto ================================================================
later(function()
	add({
		source = "quarto-dev/quarto-nvim",
		depends = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter" },
	})
	require("quarto").setup({
		lspFeatures = {
			enabled = true,
		},
		completion = { enabled = true },
		codeRunner = {
			enabled = true,
			default_method = "iron",
		},
	})
	-- Activate
	Config.nmap_leader("qa", "<cmd>QuartoActivate<cr>", "Activate")
	-- Preview
	Config.nmap_leader("qp", "<cmd>QuartoPreview<cr>", "Preview")
	Config.nmap_leader("qP", "<cmd>QuartoClosePreview<cr>", "Close Preview")
	-- Send
	Config.nmap_leader("qs", "<cmd>QuartoSend<cr>", "Send Cell")
	Config.nmap_leader("ql", "<cmd>QuartoSendLine<cr>", "Send Line")
	Config.nmap_leader("qu", "<cmd>QuartoSendAbove<cr>", "Send Above")
	Config.nmap_leader("qd", "<cmd>QuartoSendBelow<cr>", "Send Below")
	Config.nmap_leader("qA", "<cmd>QuartoSendAll<cr>", "Send All")
end)
