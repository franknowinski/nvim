return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tab", -- Use buffers mode to disable tabs
			separator_style = "slant",
			show_tab_indicators = false, -- Disable tab indicators
			show_buffer_close_icons = true, -- Show close icons only for buffers
			show_close_icon = false, -- Disable the global close icon
			always_show_bufferline = true, -- Always show the bufferline without tabs
			enforce_regular_tabs = false, -- Disable regular tabs
			indicator = {
				style = "none", -- Remove indicators from tabs
			},
			numbers = "none", -- Disable numbering of buffers
			diagnostics = false, -- Disable diagnostics in bufferline
			close_command = "bdelete! %d", -- Custom close command to ensure buffers close correctly
			right_mouse_command = "bdelete! %d", -- Right-click close command
		},
		-- options = {
		--   mode = "tabs",
		--   separator_style = "slant",
		--   indicator = {
		--     style = 'none', -- This removes the `?` at the end of the tab
		--   },
		-- },
	},
}
