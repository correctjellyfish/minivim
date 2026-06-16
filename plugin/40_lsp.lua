-- LSP Config
local add, later, now_if_args = vim.pack.add, Config.later, Config.now_if_args

now_if_args(function()
	add({ "https://github.com/neovim/nvim-lspconfig" })

	vim.lsp.enable({
		-- == Ada ==
		"ada_ls",
		-- == C/C++ ==
		"clangd",
		"cmake",
		-- == Fortran ==
		"fortls",
		-- == Go ==
		"gopls",
		-- == Java ==
		"jdtls",
		-- == Javascript/Typescript ==
		"denols",
		-- == Lean ==
		"leanls",
		-- == Lua ==
		"lua_ls",
		-- == Markdown ==
		"marksman",
		"harper_ls",
		"mdformat",
		-- == Ocaml ==
		"ocamllsp",
		-- == Python ==
		-- "pyright",
		-- "pylsp",
		"ruff",
		-- "pyrefly",
		"ty",
		-- == R ==
		"r_language_server",
		-- == Shell ==
		"bashls",
		"fish_lsp",
		-- == Typst ==
		"tinymist",
		-- == Zig ==
		"zls",
		-- == Config ==
		"jsonls", -- JSON
		"lemminx", -- XML
		"yamlls", -- YAML
		"taplo", -- TOML
	})
end)

later(function()
	-- Configure the correct python provider
	vim.g.python_host_prog = "~/environments/pynvim/.venv/bin/python"
	vim.g.python3_host_prog = "~/environments/pynvim/.venv/bin/python"

	-- Add and setup Mason
	add({ "https://github.com/mason-org/mason.nvim" })
	require("mason").setup({})

	-- Add and setup Lazydev
	add({ "https://github.com/folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end)

-- Fidget =============================================================
later(function()
	add({ "https://github.com/j-hui/fidget.nvim" })
	require("fidget").setup({})
end)
