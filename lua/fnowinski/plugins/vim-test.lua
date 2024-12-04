return {
	{
		"vim-test/vim-test",
		requires = { "tpope/vim-dispatch", "preservim/vimux" },
		config = function()
			-- Configure vim-test
			vim.g["test#ruby#rspec#options"] = {
				file = "--format documentation",
				suite = "--tag ~slow",
			}
			vim.g["test#strategy"] = "vimux"
			vim.g["test#javascript#jest#file_pattern"] = ".*\\.spec\\.js"

			-- Add key mappings for running tests
			vim.api.nvim_set_keymap("n", "<space>t", ":TestNearest<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<space>T", ":TestFile<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<space>l", ":TestLast<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"tpope/vim-dispatch",
		event = "VeryLazy",
	},
  {
    "preservim/vimux",
    event = "VimEnter",
  },
}
