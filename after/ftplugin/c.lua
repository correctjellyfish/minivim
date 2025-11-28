vim.keymap.set("i", "<M-->", "->", { desc = "Insert arrow" })
vim.keymap.set("n", "<leader>lh", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch to header/source" })
vim.keymap.set("n", "<leader>lI", "<cmd>LspClangdShowSymbolInfo<cr>", { desc = "Show symbol info" })
