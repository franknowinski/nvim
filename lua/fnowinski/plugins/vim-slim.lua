return {
	"slim-template/vim-slim",
	event = { "BufReadPre", "BufNewFile" },
	ft = "slim",
	config = function()
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			pattern = { "*.slim" },
			command = "set ft=slim",
		})
	end,
}
