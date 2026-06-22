-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- More Colorschemes (Used with switch colorscheme keymap) ===========
later(function()
	add({
		"https://github.com/rktjmp/lush.nvim",
		{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
		"https://github.com/oxfist/night-owl.nvim",
		"https://github.com/thesimonho/kanagawa-paper.nvim",
		"https://github.com/scottmckendry/cyberdream.nvim",
		"https://github.com/slugbyte/lackluster.nvim",
		"https://github.com/maxmx03/fluoromachine.nvim",
		"https://github.com/uloco/bluloco.nvim",
		"https://github.com/kdheepak/monochrome.nvim",
		"https://github.com/yorik1984/newpaper.nvim",
		"https://github.com/ianklapouch/wildberries.nvim",
		"https://github.com/Abstract-IDE/Abstract-cs",
		"https://github.com/idr4n/github-monochrome.nvim",
	})
end)
