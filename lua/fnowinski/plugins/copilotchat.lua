return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			debug = false,
			model = "claude-sonnet-4",
			mappings = {
				complete = {
					detail = "<C-o><C-o>",
					insert = "<C-o><C-o>",
				},
				reset = {
					normal = "<C-r>",
					insert = "<C-r>",
				},
			},
		},
	},
}
