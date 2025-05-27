return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
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
				python = { "ruff_format" },
				ruby = { "standardrb" },
				ruby_spec = { "rubocop" },
				vue = { "prettier" },
				eruby = { "htmlbeautifier" },
				slim = { "htmlbeautifier" },
			},
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
