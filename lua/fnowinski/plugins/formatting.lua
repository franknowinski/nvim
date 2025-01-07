return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "eslint_custom" },
				typescriptreact = { "eslint_custom" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				yml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				ruby = { "standardrb" },
				ruby_spec = { "rubocop" },
				slim = { "prettier" },
				vue = { "prettier" }
			},
			-- format_on_save = {
			-- 	lsp_fallback = false,
			-- 	async = false,
			-- 	timeout_ms = 2000,
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<space>P", function()
			conform.format({
				lsp_fallback = false,
				async = true,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
