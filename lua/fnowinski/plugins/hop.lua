return {
	"phaazon/hop.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local hop = require("hop")
		local keymap = vim.keymap
		hop.setup()


		keymap.set('n', 'sl', function()
			hop.hint_char2()
		end, {remap = true})
	end,
}
