return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	build = "make",
	paste = {
		enable = false, -- disables the paste keybinding
	},
	opts = {
		providers = {
			copilot = {
				model = "gpt-4-1106-preview",
			},
		},
		permissions = {
			allow_file_changes = true,
		},
		debug = false,
		auto_suggestions_provider = "copilot",
		mappings = {
			ask = "<leader>A",
			refresh = "<leader>AR",
			edit = "<leader>AE",
			files = {
				add_current = "<leader>Aa", -- Add current buffer to selected files
			},
		},
		windows = {
			width = 50,
		},
		hints = {
			enabled = false,
		},
		repo_map = {
			ignore_patterns = {
				"%.git",
				"%.worktree",
				"spec/*",
				"node_modules",
				".ruby*",
				"dist",
				"build",
				"*.log",
				"*.tmp",
			},
			negate_patterns = {},
		},
		file_selector = {
			provider = "telescope",
		},
	},
	-- paste = {
	-- 	enable = false, -- disables the paste keybinding
	-- },
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
			keys = false,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
