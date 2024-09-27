return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			debug = true,
			mappings = {
				complete = {
					detail = '<C-o><C-o>',
					insert = '<C-o><C-o>',
				},
				reset = {
					normal = "<C-r>",
					insert = "<C-r>",
				},
			},
		},
	},
}
