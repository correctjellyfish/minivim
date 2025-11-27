-- Make concise helpers for installing/adding plugins in two stages
local add, later = MiniDeps.add, MiniDeps.later

-- More Colorschemes (Used with switch colorscheme keymap) ===========
later(function()
	add("oxfist/night-owl.nvim")
	add("thesimonho/kanagawa-paper.nvim")
	add("scottmckendry/cyberdream.nvim")
	add("slugbyte/lackluster.nvim")
	add("maxmx03/fluoromachine.nvim")
	add({ source = "uloco/bluloco.nvim", depends = { "rktjmp/lush.nvim" } })
	add("kdheepak/monochrome.nvim")
	add("yorik1984/newpaper.nvim")
	add("ianklapouch/wildberries.nvim")
	add("Abstract-IDE/Abstract-cs")
	add("idr4n/github-monochrome.nvim")
end)
