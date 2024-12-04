return {
	{
		"williamboman/mason.nvim",
		event = "BufReadPre",
		config = function()
			local mason = require("mason")
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"tsserver",
					"html",
					"cssls",
					"tailwindcss",
					"svelte",
					"lua_ls",
					"graphql",
					"emmet_ls",
					"prismals",
					"pyright",
					"ruby_lsp",
					"rubocop",
					"solargraph",
					"yamllint",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		after = "mason.nvim",
		config = function()
			local mason_tool_installer = require("mason-tool-installer")
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"isort",
					"black",
					"rubocop",
					"standardrb",
				},
			})
		end,
	},
}
