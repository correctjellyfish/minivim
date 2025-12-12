-- A Neovim config heavily using the Mini plugin suite
--    _____  .__       .______   ____.__
--   /     \ |__| ____ |__\   \ /   /|__| _____
--  /  \ /  \|  |/    \|  |\   Y   / |  |/     \
-- /    Y    \  |   |  \  | \     /  |  |  Y Y  \
-- \____|__  /__|___|  /__|  \___/   |__|__|_|  /
--         \/        \/                       \/
-- Started from a MiniMax base config (https://github.com/nvim-mini/MiniMax)

-- Bootstrap 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local origin = "https://github.com/nvim-mini/mini.nvim"
	local clone_cmd = { "git", "clone", "--filter=blob:none", origin, mini_path }
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Setup the Mini plugin manager (since the now/later helpers are needed throughout)
require("mini.deps").setup()

-- Global config table for passing data
_G.Config = {}

-- Autocommand helper
local gr = vim.api.nvim_create_augroup("custom-config", {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
	local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
	vim.api.nvim_create_autocmd(event, opts)
end

-- Create a function to delay plugin loading if no args provided to nvim
_G.Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
