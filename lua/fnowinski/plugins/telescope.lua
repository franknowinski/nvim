return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "TelescopeResults",
			callback = function(ctx)
				vim.api.nvim_buf_call(ctx.buf, function()
					vim.fn.matchadd("TelescopeParent", "\t\t.*$")
					vim.api.nvim_set_hl(0, "TelescopeParent", {
						link = "Comment",
						fg = "#005158", -- Bright yellow color in hex
					})
				end)
			end,
		})

		local function filenameFirst(_, path)
			local tail = vim.fs.basename(path)
			local parent = vim.fs.dirname(path)
			if parent == "." then
				return tail
			end
			return string.format("%s\t\t%s", tail, parent)
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<Esc>"] = actions.close, -- Close Telescope in insert mode
						["<C-p>"] = actions.close, -- Close Telescope in insert mode
					},
				},
				layout_config = {
					vertical = {
						width = { padding = 1 },
						height = { padding = 1 },
					},
					horizontal = {
						width = { padding = 1 },
						height = { padding = 1 },
					},
				},
			},
			pickers = {
				find_files = {
					path_display = filenameFirst,
				},
				live_grep = {
					path_display = filenameFirst,
				},
				grep_string = {
					path_display = filenameFirst,
				},
				lsp_definitions = {
					path_display = filenameFirst,
				},
				lsp_definitions = {
					path_display = filenameFirst,
				},
				buffers = {
					ignore_current_buffer = true,
					sort_lastused = true,
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
					},
				},
			},
			file_ignore_patterns = {
				"node_modules",
				"spec/vcr/*",
				"log",
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- Override the generic sorter with fzf's
					override_file_sorter = true, -- Override the file sorter with fzf's
					case_mode = "smart_case", -- or "respect_case" or "smart_case"
				},
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>jr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })

		-- keymap.set("n", "<space>aa", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<space>aa", builtin.live_grep, {})

		keymap.set("n", "<leader>aa", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>jt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>m", "<cmd>Telescope buffers<cr>", { desc = "Find files in buffer" })

		-- Custom function to search in app directory
		local function find_files_in_dir(dir)
			builtin.find_files({
				search_dirs = { dir },
				-- You can add additional_args here if needed
			})
		end

		-- Function to search files in the current directory
		local function find_files_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
			builtin.find_files({
				search_dirs = { current_dir },
			})
		end
		keymap.set("n", "<leader>fd", find_files_in_current_dir, { desc = "Find files in current directory" })

		keymap.set("n", "<leader>fa", function()
			find_files_in_dir("app")
		end, { desc = "Find files in app directory" })
		keymap.set("n", "<leader>fm", function()
			find_files_in_dir("app/models")
		end, { desc = "Find files in app/models directory" })
		keymap.set("n", "<leader>fc", function()
			find_files_in_dir("app/controllers")
		end, { desc = "Find files in app/controllers directory" })
		keymap.set("n", "<leader>fv", function()
			find_files_in_dir("app/views")
		end, { desc = "Find files in app/views directory" })
		keymap.set("n", "<leader>fh", function()
			find_files_in_dir("app/helpers")
		end, { desc = "Find files in app/helpers directory" })
		keymap.set("n", "<leader>fs", function()
			find_files_in_dir("app/services")
		end, { desc = "Find files in app/services directory" })
		keymap.set("n", "<leader>fw", function()
			find_files_in_dir("app/workers")
		end, { desc = "Find files in app/workers directory" })
		keymap.set("n", "<leader>fr", function()
			find_files_in_dir("app/javascript_apps")
		end, { desc = "Find files in app/javascript_apps directory" })
		keymap.set("n", "<leader>fe", function()
			find_files_in_dir("app/services/distribution_system")
		end, { desc = "Find files in app/services/distribution_system directory" })
		keymap.set("n", "<leader>fl", function()
			find_files_in_dir("lib")
		end, { desc = "Find files in lib directory" })
		keymap.set("n", "<leader>fi", function()
			find_files_in_dir("infra")
		end, { desc = "Find files in infra directory" })
		keymap.set("n", "<leader>fp", function()
			find_files_in_dir("public")
		end, { desc = "Find files in public directory" })
		keymap.set("n", "<leader>ft", function()
			find_files_in_dir("spec")
		end, { desc = "Find files in spec directory" })
		keymap.set("n", "<leader>fC", function()
			find_files_in_dir("config")
		end, { desc = "Find files in config directory" })
		keymap.set("n", "<leader>fD", function()
			find_files_in_dir("db")
		end, { desc = "Find files in db directory" })
		keymap.set("n", "<leader>fF", function()
			find_files_in_dir("spec/factories")
		end, { desc = "Find files in spec/factories directory" })

		-- grep words in directory
		-- local function grep_word_in_dir(dir)
		-- 	require("telescope.builtin").live_grep({
		-- 		search_dirs = { dir },
		-- 	})
		-- end

		-- grep words in directory
		local function grep_word_in_dir(dir)
			require("telescope.builtin").grep_string({
				shorten_path = true,
				word_match = "-w",
				only_sort_text = true,
				search = "",
				search_dirs = { dir },
			})
		end

		-- grep words in current directory
		local function grep_word_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
			require("telescope.builtin").live_grep({
				search_dirs = { current_dir },
			})
		end
		keymap.set("n", "<space>sd", grep_word_in_current_dir, { desc = "Grep word in current directory" })

		keymap.set("n", "<space>sa", function()
			grep_word_in_dir("app")
		end, { desc = "Search word in app directory" })

		keymap.set("n", "<space>sm", function()
			grep_word_in_dir("app/models")
		end, { desc = "Search word in app/models directory" })

		keymap.set("n", "<space>sc", function()
			grep_word_in_dir("app/controllers")
		end, { desc = "Search word in app/controllers directory" })

		keymap.set("n", "<space>sv", function()
			grep_word_in_dir("app/views")
		end, { desc = "Search word in app/views directory" })

		keymap.set("n", "<space>sh", function()
			grep_word_in_dir("app/helpers")
		end, { desc = "Search word in app/helpers directory" })

		keymap.set("n", "<space>ss", function()
			grep_word_in_dir("app/services")
		end, { desc = "Search word in app/services directory" })

		keymap.set("n", "<space>sw", function()
			grep_word_in_dir("app/workers")
		end, { desc = "Search word in app/workers directory" })

		keymap.set("n", "<space>sr", function()
			grep_word_in_dir("app/javascript_apps")
		end, { desc = "Search word in app/javascript_apps directory" })

		keymap.set("n", "<space>se", function()
			grep_word_in_dir("app/services/distribution_system")
		end, { desc = "Search word in app/services/distribution_system directory" })

		keymap.set("n", "<space>sl", function()
			grep_word_in_dir("lib")
		end, { desc = "Search word in lib directory" })

		keymap.set("n", "<space>si", function()
			grep_word_in_dir("infra")
		end, { desc = "Search word in infra directory" })

		keymap.set("n", "<space>sp", function()
			grep_word_in_dir("public")
		end, { desc = "Search word in public directory" })

		keymap.set("n", "<space>st", function()
			grep_word_in_dir("spec")
		end, { desc = "Search word in spec directory" })

		keymap.set("n", "<space>sC", function()
			grep_word_in_dir("config")
		end, { desc = "Search word in config directory" })

		keymap.set("n", "<space>sD", function()
			grep_word_in_dir("db")
		end, { desc = "Search word in db directory" })

		keymap.set("n", "<space>sf", function()
			grep_word_in_dir("spec/factories")
		end, { desc = "Search word in spec/factories directory" })

		keymap.set("n", "<space>sF", function()
			grep_word_in_dir("app/forms")
		end, { desc = "Search word in app/forms directory" })

		local function grep_word_under_cursor_in_dir(dir)
			local word = vim.fn.expand("<cword>") -- Get the word under the cursor
			require("telescope.builtin").live_grep({
				search_dirs = { dir },
				default_text = word,
			})
		end

		-- grep words in under cursor in current directory
		local function grep_word_under_cursor_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
			local word = vim.fn.expand("<cword>") -- Get the word under the cursor
			require("telescope.builtin").live_grep({
				search_dirs = { current_dir },
				default_text = word,
			})
		end

		keymap.set(
			"n",
			"<leader>sd",
			grep_word_under_cursor_in_current_dir,
			{ desc = "Grep word in current directory" }
		)

		-- Key mappings
		keymap.set("n", "<leader>sa", function()
			grep_word_under_cursor_in_dir("app")
		end, { desc = "Grep word in app directory" })

		keymap.set("n", "<leader>sm", function()
			grep_word_under_cursor_in_dir("app/models")
		end, { desc = "Grep word in app/models directory" })

		keymap.set("n", "<leader>sc", function()
			grep_word_under_cursor_in_dir("app/controllers")
		end, { desc = "Grep word in app/controllers directory" })

		keymap.set("n", "<leader>sv", function()
			grep_word_under_cursor_in_dir("app/views")
		end, { desc = "Grep word in app/views directory" })

		keymap.set("n", "<leader>sh", function()
			grep_word_under_cursor_in_dir("app/helpers")
		end, { desc = "Grep word in app/helpers directory" })

		keymap.set("n", "<leader>ss", function()
			grep_word_under_cursor_in_dir("app/services")
		end, { desc = "Grep word in app/services directory" })

		keymap.set("n", "<leader>sw", function()
			grep_word_under_cursor_in_dir("app/workers")
		end, { desc = "Grep word in app/workers directory" })

		keymap.set("n", "<leader>sr", function()
			grep_word_under_cursor_in_dir("app/javascript_apps")
		end, { desc = "Grep word in app/javascript_apps directory" })

		keymap.set("n", "<leader>se", function()
			grep_word_under_cursor_in_dir("app/services/distribution_system")
		end, { desc = "Grep word in app/services/distribution_system directory" })

		keymap.set("n", "<leader>sl", function()
			grep_word_under_cursor_in_dir("lib")
		end, { desc = "Grep word in lib directory" })

		keymap.set("n", "<leader>si", function()
			grep_word_under_cursor_in_dir("infra")
		end, { desc = "Grep word in infra directory" })

		keymap.set("n", "<leader>sp", function()
			grep_word_under_cursor_in_dir("public")
		end, { desc = "Grep word in public directory" })

		keymap.set("n", "<leader>st", function()
			grep_word_under_cursor_in_dir("spec")
		end, { desc = "Grep word in spec directory" })

		keymap.set("n", "<leader>sC", function()
			grep_word_under_cursor_in_dir("config")
		end, { desc = "Grep word in config directory" })

		keymap.set("n", "<leader>sD", function()
			grep_word_under_cursor_in_dir("db")
		end, { desc = "Grep word in db directory" })

		keymap.set("n", "<leader>sf", function()
			grep_word_under_cursor_in_dir("spec/factories")
		end, { desc = "Grep word in spec/factories directory" })

		keymap.set("n", "<leader>sF", function()
			grep_word_under_cursor_in_dir("app/forms")
		end, { desc = "Grep word in app/forms directory" })
		telescope.load_extension("fzf")
	end,
}
