-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- Rust ===================================================================
later(function()
	add({ "https://github.com/mrcjkb/rustaceanvim" })
	add({ "https://github.com/Saecki/crates.nvim" })
	require("crates").setup({})
end)
