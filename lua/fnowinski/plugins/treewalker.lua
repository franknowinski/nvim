return {
	"aaronik/treewalker.nvim",
	opts = {
		highlight = true,
	},
	config = function()
		vim.api.nvim_set_keymap("n", "<A-j>", ":silent Treewalker Down<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<A-k>", ":silent Treewalker Up<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<A-h>", ":silent Treewalker Left<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<A-l>", ":silent Treewalker Right<CR>", { noremap = true, silent = true })
	end,
}
