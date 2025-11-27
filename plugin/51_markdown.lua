-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Markdown =================================================================

later(function()
	add("MeanderingProgrammer/render-markdown.nvim")
	require("render-markdown").setup({})
end)

-- Obsidian ==================================================================
later(function()
	add("obsidian-nvim/obsidian.nvim")
	require("obsidian").setup({
		legacy_commands = false,
		workspaces = {
			{
				name = "pumice",
				path = "~/Notes/pumice",
			},
		},
	})
	Config.nmap_leader("On", ":Obsidian new ", "New Note")
	Config.nmap_leader("OS", "<cmd>Obsidian quick_switch<cr>", "Switch")
	Config.nmap_leader("Os", "<cmd>Obsidian search<cr>", "Search")
	Config.nmap_leader("OR", ":Obsidian rename ", "Rename")
	Config.nmap_leader("Oc", "<cmd>Obsidian toggle_checkbox<cr>", "Toggle Checkbox")
	Config.nmap_leader("Ol", "<cmd>Obsidian links<cr>", "Links")
	Config.nmap_leader("Ot", "<cmd>Obsidian toc<cr>", "Contents")

	-- Visual Mode keymaps
	vim.keymap.set("x", "<leader>Oe", ":Obsidian extract_note ", { desc = "Extract" })
	vim.keymap.set("x", "<leader>Ol", ":Obsidian link ", { desc = "Link" })
	vim.keymap.set("x", "<leader>OL", ":Obsidian link_new ", { desc = "Link New" })
end)
