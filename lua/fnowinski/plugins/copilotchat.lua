return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		-- branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			debug = true,
			--model = "claude-3.5-sonnet",
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
