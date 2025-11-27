-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Rust ===================================================================
later(function()
	add("mrcjkb/rustaceanvim")
	add("Saecki/crates.nvim")
	require("crates").setup({})
end)
