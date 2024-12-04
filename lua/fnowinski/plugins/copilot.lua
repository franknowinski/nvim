return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<Tab>", -- Map Tab to accept Copilot suggestions
						next = "<C-j>",  -- Optional: navigate to the next suggestion
						prev = "<C-k>",  -- Optional: navigate to the previous suggestion
						dismiss = "<C-c>" -- Optional: dismiss the suggestion
					},
				},
				panel = {
					enabled = true,
				},
			})
		end,
	},
}
