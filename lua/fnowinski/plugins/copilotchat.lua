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
			model = "claude-3.7-sonnet",
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
