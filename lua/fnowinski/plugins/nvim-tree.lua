return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		local devicons = require("nvim-web-devicons")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- Adjust the padding for icons
		devicons.setup({
			override = {
				default = {
					icon = " ",
					color = "#6d8086",
					name = "Default",
					padding = "  ", -- Add two spaces as padding
				},
			},
			color_icons = true,
			default = true,
		})

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = false,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = false,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = " ", -- arrow when folder is closed
							arrow_open = " ", -- arrow when folder is open
						},
					},
				},
				indent_width = 4,
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
				dotfiles = false,
			},
			git = {
				ignore = false,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
