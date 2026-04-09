return {
  on_attach = function(client, bufnr)
        vim.keymap.set("n", "<leader>lp", function()
            client:exec_cmd({
                title = "pin",
                command = "tinymist.pinMain",
                arguments = { vim.api.nvim_buf_get_name(0) },
            }, { bufnr = bufnr })
        end, { desc = "Tinymist [P]in", noremap = true })

        vim.keymap.set("n", "<leader>lu", function()
            client:exec_cmd({
                title = "unpin",
                command = "tinymist.pinMain",
                arguments = { vim.v.null },
            }, { bufnr = bufnr })
        end, { desc = "Tinymist [U]npin", noremap = true })
    end,
}
