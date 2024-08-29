return {
	"nvim-treesitter/nvim-treesitter",
	event = { "bufreadpre", "bufnewfile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = { enable = false },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"ruby",
				"json",
				"javascript",
				"typescript",
				"yaml",
				"html",
				"css",
				"markdown",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"tsx",
				"prisma",
				"markdown_inline",
				"svelte",
				"graphql",
				"query",
				"vimdoc",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					scope_incremental = "<CR>",
					node_incremental = "<TAB>",
					node_decremental = "<S-TAB>",
				},
			},
		})
	end,
}
