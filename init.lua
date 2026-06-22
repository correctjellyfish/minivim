-- A Neovim config heavily using the Mini plugin suite
--    _____  .__       .______   ____.__
--   /     \ |__| ____ |__\   \ /   /|__| _____
--  /  \ /  \|  |/    \|  |\   Y   / |  |/     \
-- /    Y    \  |   |  \  | \     /  |  |  Y Y  \
-- \____|__  /__|___|  /__|  \___/   |__|__|_|  /
--         \/        \/                       \/
-- Started from a MiniMax base config (https://github.com/nvim-mini/MiniMax)

-- Global config table for passing data
_G.Config = {}

-- Autocommand helper
local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
	local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
	vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
	local f = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd(plugin_name)
		end
		callback(ev.data)
	end
	Config.new_autocmd("PackChanged", "*", f, desc)
end

-- Use vim.pack to add minivim, and common dependencies
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
})

-- Some helpers for package loading '
local misc = require("mini.misc")
Config.now = function(f)
	misc.safely("now", f)
end
Config.later = function(f)
	misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f)
	misc.safely("event:" .. ev, f)
end
Config.on_filetype = function(ft, f)
	misc.safely("filetype:" .. ft, f)
end
