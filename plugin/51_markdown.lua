-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- Markdown =================================================================

later(function()
	add("MeanderingProgrammer/render-markdown.nvim")
	require("render-markdown").setup({})
end)
