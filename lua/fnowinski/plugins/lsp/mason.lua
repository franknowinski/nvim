return {
	{
		"williamboman/mason.nvim",
		version = "v1.10.0", -- Last stable v1.x release
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "v1.32.0", -- Latest stable release
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"cssls",
				"emmet_ls",
				"graphql",
				"html",
				"lua_ls",
				"prismals",
				"pyright",
				"ruby_lsp",
				"solargraph",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"yamlls",
			},
			automatic_installation = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"rubocop",
				"standardrb",
			},
		},
	},
}
