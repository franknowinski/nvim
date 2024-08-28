return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
	},
	keys = {
		-- Will use Telescope if installed or a vim.ui.select picker otherwise
		{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
		{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
	},
	config = function()
		-- Setup auto-session
		require("auto-session").setup({
			session_lens = {
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
				mappings = {
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
				},
			},
		})

		-- Set session options
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		-- Define the custom command to clear all buffers and open a new one
		vim.api.nvim_create_user_command("ClearAllBuffers", function()
			vim.cmd("bufdo bd")
			vim.cmd("enew")
		end, {})

		-- Create a keybinding to run the custom command
		vim.api.nvim_set_keymap("n", "<leader>cb", ":ClearAllBuffers<CR>", { noremap = true, silent = true })
	end,
}
