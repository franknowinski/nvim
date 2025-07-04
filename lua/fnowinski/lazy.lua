local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Disable auto-indenting for certain file types
vim.cmd([[autocmd FileType ruby setlocal indentkeys-=<:]])

local imports = {
	-- { import = "fnowinski.plugins.avante" },
	{ import = "fnowinski.plugins.telescope"},
	{ import = "fnowinski.plugins.abolish" },
	{ import = "fnowinski.plugins.alpha" },
	-- { import = "fnowinski.plugins.autosession" },
	{ import = "fnowinski.plugins.autopairs" },
	-- { import = "fnowinski.plugins.bufferline" },
	{ import = "fnowinski.plugins.colorscheme" },
	{ import = "fnowinski.plugins.copilot" },
	{ import = "fnowinski.plugins.copilotchat" },
	{ import = "fnowinski.plugins.comment" },
	{ import = "fnowinski.plugins.dressing" },
	{ import = "fnowinski.plugins.hop" },
	{ import = "fnowinski.plugins.endwise" },
	{ import = "fnowinski.plugins.formatting" },
	{ import = "fnowinski.plugins.gitsigns" },
	{ import = "fnowinski.plugins.indent-blankline" },
	{ import = "fnowinski.plugins.init" },
	{ import = "fnowinski.plugins.lualine" },
	{ import = "fnowinski.plugins.neotags" },
	{ import = "fnowinski.plugins.noice" },
	{ import = "fnowinski.plugins.nvim-cmp" },
	{ import = "fnowinski.plugins.nvim-colorizer" },
	{ import = "fnowinski.plugins.nvim-tree" },
	{ import = "fnowinski.plugins.splitjoin" },
	{ import = "fnowinski.plugins.substitute" },
	{ import = "fnowinski.plugins.surround" },
	{ import = "fnowinski.plugins.tagbar" },
	{ import = "fnowinski.plugins.todo-comments" },
	{ import = "fnowinski.plugins.treesitter" },
	{ import = "fnowinski.plugins.treewalker" },
	{ import = "fnowinski.plugins.trouble" },
	{ import = "fnowinski.plugins.vim-bundler" },
	{ import = "fnowinski.plugins.vim-fugitive" },
	{ import = "fnowinski.plugins.vim-gitgutter" },
	{ import = "fnowinski.plugins.vim-maximizer" },
	{ import = "fnowinski.plugins.vim-rhubarb" },
	{ import = "fnowinski.plugins.vim-slim" },
	{ import = "fnowinski.plugins.vim-test" },
	{ import = "fnowinski.plugins.vim-wiki" },
	{ import = "fnowinski.plugins.which-key" },
	{ import = "fnowinski.plugins.vim-ruby" },
	{ import = "fnowinski.plugins.vim-rails" },
	{ import = "fnowinski.plugins.lsp" },
	{ import = "fnowinski.plugins.winresizer" },
	{ import = "fnowinski.plugins.linting" },
}

require("lazy").setup({ imports }, {
	-- require("lazy").setup({ { import = "fnowinski.plugins" }, { import = "fnowinski.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
