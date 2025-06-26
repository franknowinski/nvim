return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			ruby = { "rubocop" },
			ruby_spec = { "rubocop" },
			mjs = { "eslint_d" }, -- Add this line
			-- vue = { "eslint_d" }
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.diagnostic.config({
			virtual_text = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN] = "󰀦",
					[vim.diagnostic.severity.HINT] = "󰌶",
					[vim.diagnostic.severity.INFO] = "󰋽"
				},
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN] = "󰀦",
					[vim.diagnostic.severity.HINT] = "󰌶",
					[vim.diagnostic.severity.INFO] = "󰋽"
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		vim.keymap.set("n", "<leader>L", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
