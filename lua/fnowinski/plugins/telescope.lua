return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
		},
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
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<Esc>"] = actions.close, -- Close Telescope in insert mode
						["<C-p>"] = actions.close, -- Close Telescope in insert mode
						["<C-n>"] = actions.cycle_history_next,
						["<C-h>"] = actions.cycle_history_prev,
					},
				},
				layout_config = {
					vertical = {
						width = { padding = 1 },
						height = { padding = 1 },
						preview_cutoff = 40,
					},
					horizontal = {
						width = { padding = 1 },
						height = { padding = 1 },
						-- preview_width = 0.4, -- Set preview pane width to 40% of the total width
						-- results_width = 0.6,
					},
				},
			},
			pickers = {
				find_files = {
					path_display = filenameFirst,
				},
				old_files = {
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
				buffers = {
					path_display = filenameFirst,
					ignore_current_buffer = true,
					sort_lastused = false,
					sort_mru = true,
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
				live_grep_args = {
					path_display = filenameFirst, 
				},
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		-- keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>ff", function()
			require("telescope.builtin").find_files({
				find_command = { "rg", "--ignore", "--hidden", "--files", "-u" }, -- Custom command
			})
		end, { desc = "Fuzzy find files including hidden files with custom rg options" })

		-- keymap.set("n", "<leader>jr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<space>jk", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>aa", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>jt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		keymap.set("n", "<leader>m", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find recent files" })
		-- keymap.set("n", "<leader>m", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		-- keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Find files in buffer" })

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
		local function grep_word_in_dir(dir)
			require("telescope.builtin").grep_string({
				shorten_path = true,
				word_match = "-w",
				only_sort_text = true,
				search = "",
				search_dirs = dir and { dir } or nil,
			})
		end

		keymap.set("n", "<space>fa", function()
			local exclusions = {
				"!**/spec/vcr/**",
				"!**/*.yml",
				"!**/*.json",
				"!**/*.sql",
				"!**/*.md",
				"!**/*.csv",
				"!**/*.lock",
				"!**/*.yaml",
				"!**/*Gemfile",
				"!**/*enc",
				"!**/*sh",
			}

			local args = {}
			for _, pattern in ipairs(exclusions) do
				table.insert(args, "--glob")
				table.insert(args, pattern)
			end

			require("telescope.builtin").grep_string({
				shorten_path = true,
				word_match = "-w",
				only_sort_text = true,
				search = "",
				additional_args = function()
					return args
				end,
			})
		end, { desc = "Grep word in project" })

		-- grep words in current directory
		local function grep_word_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
			require("telescope.builtin").live_grep({
				search_dirs = { current_dir },
			})
		end

		keymap.set("n", "<space>fd", grep_word_in_current_dir, { desc = "Grep word in current directory" })

		keymap.set("n", "<space>fa", function()
			grep_word_in_dir("app")
		end, { desc = "Search word in app directory" })

		keymap.set("n", "<space>fm", function()
			grep_word_in_dir("app/models")
		end, { desc = "Search word in app/models directory" })

		keymap.set("n", "<space>fc", function()
			grep_word_in_dir("app/controllers")
		end, { desc = "Search word in app/controllers directory" })

		keymap.set("n", "<space>fv", function()
			grep_word_in_dir("app/views")
		end, { desc = "Search word in app/views directory" })

		keymap.set("n", "<space>fh", function()
			grep_word_in_dir("app/helpers")
		end, { desc = "Search word in app/helpers directory" })

		keymap.set("n", "<space>fs", function()
			grep_word_in_dir("app/services")
		end, { desc = "Search word in app/services directory" })

		keymap.set("n", "<space>fw", function()
			grep_word_in_dir("app/workers")
		end, { desc = "Search word in app/workers directory" })

		keymap.set("n", "<space>fr", function()
			grep_word_in_dir("app/javascript")
		end, { desc = "Search word in app/javascript_apps directory" })

		keymap.set("n", "<space>fl", function()
			grep_word_in_dir("lib")
		end, { desc = "Search word in lib directory" })

		keymap.set("n", "<space>ft", function()
			grep_word_in_dir("spec")
		end, { desc = "Search word in spec directory" })

		keymap.set("n", "<space>fC", function()
			grep_word_in_dir("config")
		end, { desc = "Search word in config directory" })

		keymap.set("n", "<space>fD", function()
			grep_word_in_dir("db")
		end, { desc = "Search word in db directory" })

		keymap.set("n", "<space>ff", function()
			grep_word_in_dir("spec/factories")
		end, { desc = "Search word in spec/factories directory" })

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

		-- local function grep_exact_word_in_dir(dir)
		--     require("telescope").extensions.live_grep_args.live_grep_args({
		--       search_dirs = { dir },
		--       initial_query = "",  -- Leave this empty for a prompt
		--       additional_args = function(opts)
		--         return {
		--           "--hidden",
		--           "--no-ignore",
		--           "--ignore-case",
		--           "--glob", "!**/.git/**", -- Ignore .git directory
		--           "--glob", "!**/.tmp/**", -- Ignore .tmp directory
		--           "--glob", "!**/spec/vcr/**", -- Ignore /spec/vcr directory
		--           "--glob", "!**/log/**", -- Ignore /spec/vcr directory
		--           "--glob", "!**/coverage/**", -- Ignore /spec/vcr directory
		--           "--glob", "!**/public/**", -- Ignore /spec/vcr directory
		--           "--glob", "!**/config/twilio*", -- Ignore /spec/vcr directory
		--           "--glob", "!**/tags*", -- Ignore /spec/vcr directory
		--           "--glob", "!**/node_modules*", -- Ignore /spec/vcr directory
		--           "--glob", "!**/app/assets/*", -- Ignore /spec/vcr directory
		--         }
		--       end,
		--     })
		--   end

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

		local function grep_exact_word_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file

			require("telescope.builtin").live_grep({
				search_dirs = { current_dir },
			})
		end

		keymap.set(
			"n",
			"<space>sd",
			grep_exact_word_in_current_dir,
			{ desc = "Live grep word in current file's directory" }
		)

		local grep_args = {
			"--hidden",
			"--no-ignore",
			"--ignore-case",
			"--glob",
			"!**/.git/**", -- Ignore .git directory
			"--glob",
			"!**/.tmp/**", -- Ignore .tmp directory
			"--glob",
			"!**/spec/vcr/**", -- Ignore /spec/vcr directory
			"--glob",
			"!**/log/**", -- Ignore /log directory
			"--glob",
			"!**/coverage/**", -- Ignore /coverage directory
			"--glob",
			"!**/public/**", -- Ignore /public directory
			"--glob",
			"!**/config/twilio*", -- Ignore config files related to Twilio
			"--glob",
			"!**/tags*", -- Ignore tag files
			"--glob",
			"!**/yarn.lock", -- Ignore yarn files
			"--glob",
			"!**/node_modules*", -- Ignore node_modules directory
			"--glob",
			"!**/app/assets/*", -- Ignore app/assets directory
			"--glob",
			"!**/doc/*", -- Ignore doc directory
			"--glob",
			"!**/app/assets/builds/**", -- Ignore app/assets/builds directory
			"--glob",
			"!**/app/javascript/images/*", -- Ignore app/javascript/images directory
		}

		local function grep_exact_word_in_dir(dir)
			require("telescope").extensions.live_grep_args.live_grep_args({
				search_dirs = { dir },
				initial_query = "", -- Prefill query if needed
				additional_args = function(opts)
					return grep_args
				end,
			})
		end


		keymap.set("n", "<space>aa", function()
			grep_exact_word_in_dir()
		end, { desc = "Search word in app directory" })

		keymap.set("n", "<space>sa", function()
			grep_exact_word_in_dir("app")
		end, { desc = "Search word in app directory" })

		keymap.set("n", "<space>sm", function()
			grep_exact_word_in_dir("app/models")
		end, { desc = "Search word in app/models directory" })

		keymap.set("n", "<space>sc", function()
			grep_exact_word_in_dir("app/controllers")
		end, { desc = "Search word in app/controllers directory" })

		keymap.set("n", "<space>sv", function()
			grep_exact_word_in_dir("app/views")
		end, { desc = "Search word in app/views directory" })

		keymap.set("n", "<space>sh", function()
			grep_exact_word_in_dir("app/helpers")
		end, { desc = "Search word in app/helpers directory" })

		keymap.set("n", "<space>ss", function()
			grep_exact_word_in_dir("app/services")
		end, { desc = "Search word in app/services directory" })

		keymap.set("n", "<space>sw", function()
			grep_exact_word_in_dir("app/workers")
		end, { desc = "Search word in app/workers directory" })

		keymap.set("n", "<space>sr", function()
			grep_exact_word_in_dir("app/javascript_apps")
		end, { desc = "Search word in app/javascript_apps directory" })

		keymap.set("n", "<space>se", function()
			grep_exact_word_in_dir("app/services/distribution_system")
		end, { desc = "Search word in app/services/distribution_system directory" })

		keymap.set("n", "<space>sl", function()
			grep_exact_word_in_dir("lib")
		end, { desc = "Search word in lib directory" })

		keymap.set("n", "<space>st", function()
			grep_exact_word_in_dir("spec")
		end, { desc = "Search word in spec directory" })

		keymap.set("n", "<space>sC", function()
			grep_exact_word_in_dir("config")
		end, { desc = "Search word in config directory" })

		keymap.set("n", "<space>sD", function()
			grep_exact_word_in_dir("db")
		end, { desc = "Search word in db directory" })

		keymap.set("n", "<space>sf", function()
			grep_exact_word_in_dir("spec/factories")
		end, { desc = "Search word in spec/factories directory" })

		keymap.set("n", "<space>sF", function()
			grep_exact_word_in_dir("app/forms")
		end, { desc = "Search word in app/forms directory" })
	end,
}
