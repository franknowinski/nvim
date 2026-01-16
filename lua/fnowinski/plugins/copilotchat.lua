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
			-- model = "gpt-4.1",
			model = "claude-opus-4.5",
			-- model = "gpt-5",
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
