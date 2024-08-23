-- ~/.config/nvim/lua/plugins.lua or ~/.config/nvim/lua/lazy-config.lua
return {
	-- Other plugins
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*", -- Highlight all filetypes
			}, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like "red" or "blue"
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				mode = "background", -- Set the display mode.
			})
		end,
	},
}
