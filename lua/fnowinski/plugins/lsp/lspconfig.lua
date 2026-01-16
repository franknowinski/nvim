return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim", -- Add this dependency
	},
	config = function()
		local cmp = require("cmp")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Set default position encoding to avoid warnings
		capabilities.general = capabilities.general or {}
		capabilities.general.positionEncodings = { "utf-16" }

		vim.lsp.set_log_level("debug")

		require("luasnip.loaders.from_vscode").lazy_load()

		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		-- Set up the Ruby LSP server
		vim.lsp.config.ruby_lsp = {
			cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
			-- cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/ruby-lsp") },
			capabilities = capabilities,
			handlers = {
				["window/showMessage"] = function(_, result, ctx)
					if result.message:match("positionEncodings") then
						return -- Suppress this specific message
					end
					vim.lsp.handlers["window/showMessage"](nil, result, ctx)
				end,
			},
			root_dir = vim.fs.root(0, { ".git", "Gemfile" }),
			filetypes = { "ruby" },
		}
		vim.lsp.enable("ruby_lsp")

		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { ".git", "pyproject.toml", "setup.py" }),
			filetypes = { "python" },
			settings = {
				python = {
					pythonPath = "/Users/fnowinski/Projects/venv/bin/python3",
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
					},
					-- venvPath and venv are preferred over pythonPath
					venvPath = vim.fn.getcwd() .. "/venv",
					venv = "venv",
				},
			},
		}
		vim.lsp.enable("pyright")
		-- lspconfig.pyright.setup({})
		-- lspconfig.pyright.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = function(client, bufnr)
		-- 		-- Optional: add keymaps or other setup here
		-- 	end,
		-- 	settings = {
		-- 		python = {
		-- 			pythonPath = vim.fn.getcwd() .. "/venv/venv/bin/python",
		-- 		},
		-- 	},
		-- })

		vim.lsp.config.ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
			filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
		}
		vim.lsp.enable("ts_ls")

		-- Set up the Lua LSP server
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { ".git", ".luarc.json", ".luarc.jsonc" }),
			filetypes = { "lua" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		}
		vim.lsp.enable("lua_ls")

		-- Set up the Go LSP server
		vim.lsp.config.gopls = {
			cmd = { "gopls" },
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { "go.mod", "go.work", ".git" }),
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		}
		vim.lsp.enable("gopls")

		-- Setup Vue LSP server
		vim.lsp.config.vue_ls = {
			cmd = { "vue-language-server", "--stdio" },
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { "package.json", ".git" }),
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
			init_options = {
				typescript = {
					serverPath = vim.fn.expand("~/.npm-global/lib/node_modules/typescript/lib/tsserverlibrary.js"),
				},
			},
		}
		vim.lsp.enable("vue_ls")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				-- opts.desc = "Show LSP definitions"
				-- keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP definitions"
				keymap.set(
					"n",
					"gv",
					"<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='vsplit'})<CR>",
					opts
				) -- show lsp definitions
				keymap.set(
					"n",
					"gh",
					"<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='hsplit'})<CR>",
					opts
				) -- show lsp definitions
				-- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- show lsp definitions
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP definitions"
				keymap.set(
					"n",
					"gi",
					"<cmd>lua require('telescope.builtin').lsp_implementations({jump_type='vsplit'})<CR>",
					opts
				) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set(
					"n",
					"gt",
					"<cmd>lua require('telescope.builtin').lsp_type_definitions({jump_type='vsplit'})<CR>",
					opts
				) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				-- opts.desc = "Go to previous diagnostic"
				-- keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				--
				-- opts.desc = "Go to next diagnostic"
				-- keymap.set("n", "]d", vim.diagnostic.goto_next, opts) --

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
