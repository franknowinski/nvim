return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		messages = {
			enabled = false,
		},
		-- view = "mini",
		views = {
			cmdline = {
				backend = "cmdline",
				relative = "editor",
				position = {
					row = 3, -- Adjust this value to position the command input higher
					col = "30%",
				},
				size = {
					width = 90,
					height = 2,
				},
				border = {
					style = "rounded",
					text = {
						top = " Command ",
						top_align = "center",
					},
				},
			},
		},
	},
	routes = {
		{
			filter = { event = "msg_show", kind = "", find = "written" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", kind = "", find = "yank" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", kind = "", find = "Copilot" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", kind = "echo", find = "Buffer" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", kind = "", find = "created" },
			opts = { skip = true },
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
		"hrsh7th/cmp-cmdline",
	},
}

-- routes = {
-- 	{
-- 		filter = {
-- 			event = "msg_show",
-- 			kind = "",
-- 			find = "written",
-- 		},
-- 		opts = { skip = true },
-- 	},
-- 	{
-- 		filter = {
-- 			event = "msg_show",
-- 			kind = "",
-- 			find = "yank",
-- 		},
-- 		opts = { skip = true },
-- 	},
-- 	{
-- 		filter = {
-- 			event = "msg_show",
-- 			kind = "",
-- 			find = "Copilot"
-- 		},
-- 		opts = { skip = true },
-- 	},
-- 	{
-- 		filter = { event = "msg_show", kind = "echo", find = "Buffer" },
-- 		opts = { skip = true },
-- 	},
-- },
--
