return {
	"github/copilot.vim",
	event = "VimEnter",
	config = function()
		vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("\\<CR>")', { silent = true, expr = true, script = true })
	end,
}
