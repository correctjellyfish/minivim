vim.opt_local.formatoptions:remove("r")
vim.opt.formatoptions = vim.opt.formatoptions + {
	o = false,
}
vim.keymap.set("i", "<M-->", "->", { desc = "Insert arrow" })
