-- Define the plugin
return {
	"easymotion/vim-easymotion",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Key mappings for Easymotion
		-- vim.api.nvim_set_keymap("n", "s", "<Plug>(easymotion-overwin-f2)", { noremap = false, silent = true })
		-- vim.api.nvim_set_keymap("n", "/", "<Plug>(easymotion-sn)", { noremap = false, silent = true })
		-- vim.api.nvim_set_keymap("o", "/", "<Plug>(easymotion-tn)", { noremap = false, silent = true })
		-- vim.api.nvim_set_keymap("n", "n", "<Plug>(easymotion-next)", { noremap = false, silent = true })
		-- vim.api.nvim_set_keymap("n", "N", "<Plug>(easymotion-prev)", { noremap = false, silent = true })
	end,
}
