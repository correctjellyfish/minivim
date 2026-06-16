-- Make concise helpers for installing/adding plugins in two stages
local add, later, now, now_if_args = vim.pack.add, Config.later, Config.now, Config.now_if_args

-- More Colorschemes (Used with switch colorscheme keymap) ===========
later(function()
	add({ "https://github.com/rktjmp/lush.nvim" })
	add({ "https://github.com/catppuccin/nvim" })
	add({ "https://github.com/oxfist/night-owl.nvim" })
	add({ "https://github.com/thesimonho/kanagawa-paper.nvim" })
	add({ "https://github.com/scottmckendry/cyberdream.nvim" })
	add({ "https://github.com/slugbyte/lackluster.nvim" })
	add({ "https://github.com/maxmx03/fluoromachine.nvim" })
	add({ "https://github.com/uloco/bluloco.nvim" })
	add({ "https://github.com/kdheepak/monochrome.nvim" })
	add({ "https://github.com/yorik1984/newpaper.nvim" })
	add({ "https://github.com/ianklapouch/wildberries.nvim" })
	add({ "https://github.com/Abstract-IDE/Abstract-cs" })
	add({ "https://github.com/idr4n/github-monochrome.nvim" })
end)
