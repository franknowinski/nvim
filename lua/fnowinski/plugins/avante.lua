return {
	"yetone/avante.nvim",
	opts = {
		mappings = {
			ask = "<leader>A", -- your custom mapping for ask
			refresh = "<leader>AR", -- your custom mapping for refresh
			edit = "<leader>AE", -- your custom mapping for edit
		},
	},
	keys = function(_, keys)
		local opts =
			require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

		local mappings = {
			{
				opts.mappings.ask,
				function()
					require("avante.api").ask()
				end,
				desc = "avante: ask",
				mode = { "n", "v" },
			},
			{
				opts.mappings.refresh,
				function()
					require("avante.api").refresh()
				end,
				desc = "avante: refresh",
				mode = "v",
			},
			{
				opts.mappings.edit,
				function()
					require("avante.api").edit()
				end,
				desc = "avante: edit",
				mode = { "n", "v" },
			},
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	event = "VeryLazy",
	config = function()
		require("avante").setup({
			provider = "copilot", -- Change from default "claude" to "copilot"
			copilot = {
				-- Any specific Copilot settings you want to add
			},
			permissions = {
				allow_file_changes = true, -- Enable Avante to change files directly
			},
			debug = false,
			auto_suggestions_provider = "claude",
			tokenizer = {},
			openai = {},
			azure = {},
			claude = {},
			gemini = {},
			vertex = {},
			cohere = {},
			vendors = {},
			dual_boost = {},
			behaviour = {},
			history = {},
			highlights = {},
			mappings = {
				files = {
					-- add_current = "<leader>A", -- Add current buffer to selected files
				},
			},
			windows = {
				width = 50,
			},
			diff = {},
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
				}, -- ignore files matching these
				negate_patterns = {}, -- negate ignore files matching these.
			},
			file_selector = {
				provider = "telescope",
			},
			suggestion = {},
		})
	end,
	lazy = false,
	version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	build = "make",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
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
