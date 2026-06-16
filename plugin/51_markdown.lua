-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- Markdown =================================================================

later(function()
	add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
	require("render-markdown").setup({})
end)
