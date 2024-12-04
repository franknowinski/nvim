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

		local function find_project_root()
			local dir = vim.fn.expand("%:p:h") -- Get the current directory
			while dir ~= "/" do
				if vim.fn.isdirectory(dir .. "/.git") == 1 then
					return dir
				end
				dir = vim.fn.fnamemodify(dir, ":h") -- Go up one directory
			end
			return nil
		end

		local function relative_path_from_project_root(path)
			local project_root = find_project_root()
			if not project_root then
				return path -- If project root is not found, return the original path
			end
			return vim.fn.fnamemodify(path, ":p"):sub(#project_root + 2) -- Remove project root prefix
		end

		local function filenameFirst(_, path)
			local tail = vim.fs.basename(path)
			local parent = relative_path_from_project_root(vim.fs.dirname(path))

			local relative_path_with_filename = parent .. tail

			-- Format the output with the truncated parent path
			if parent == "" or parent == "." then
				return tail
			end
			return string.format("%s\t\t%s", tail, relative_path_with_filename)
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<Esc>"] = actions.close,
						["<C-p>"] = actions.close,
						["<C-n>"] = actions.cycle_history_next,
						["<C-l>"] = actions.cycle_history_prev,
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
						preview_width = 0.5, -- Set preview pane width to 40% of the total width
						results_width = 0.5,
					},
				},
			},
			file_ignore_patterns = {
				"node_modules",
				"spec/vcr/*",
				"log",
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
			extensions = {
				live_grep_args = {
					path_display = filenameFirst,
				},
			},
		})

		require("telescope").load_extension("noice")

		local exclusions = {
			"--hidden",
			"--no-ignore",
			"--ignore-case",
			"--glob",
			"!**/.git/**", -- Ignore .git directory
			"--glob",
			"!**/.tmp/**", -- Ignore .tmp directory
			"--glob",
			"!**/tmp/**", -- Ignore tmp directory
			"--glob",
			"!**/ea_templates/**", -- Ignore ea_templates
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
			"--glob",
			"!**/vendor/**", -- Ignore vendor directory
		}

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", function()
			require("telescope.builtin").find_files({
				find_command = {
					"rg",
					"--ignore",
					"--hidden",
					"--files",
					"-u",
					"--glob",
					"!**/vendor/**",
					"--glob",
					"!**/node_modules/**",
					"--glob",
					"!**/public/**",
					"--glob",
					"!**/log/**",
					"--glob",
					"!**/tmp/**",
				},
			})
		end, { desc = "Fuzzy find files including hidden files with custom rg options" })

		keymap.set("n", "<leader>A", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>jt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>m", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>re", "<cmd>Telescope resume<cr>", { desc = "Resume search" })

		-- ======================================================================
		--                          Find Files
		-- ======================================================================
		local function find_files_in_dir(dir)
			builtin.find_files({
				search_dirs = { dir },
			})
		end

		-- =======================  Current Directory  ==========================
		keymap.set("n", "<leader>fd", function()
			local current_dir = vim.fn.expand("%:p:h")
			find_files_in_dir(current_dir)
		end, { desc = "Find files in current directory" })

		-- =======================  App Directory  ==============================
		keymap.set("n", "<leader>fa", function()
			find_files_in_dir("app")
		end, { desc = "Find files in app directory" })

		-- =======================  Models Directory  ===========================
		keymap.set("n", "<leader>fm", function()
			find_files_in_dir("app/models")
		end, { desc = "Find files in app/models directory" })

		-- =======================  Controllers Directory  ======================
		keymap.set("n", "<leader>fc", function()
			find_files_in_dir("app/controllers")
		end, { desc = "Find files in app/controllers directory" })

		-- =======================  Views Directory  ============================
		keymap.set("n", "<leader>fv", function()
			find_files_in_dir("app/views")
		end, { desc = "Find files in app/views directory" })

		-- =======================  Helpers Directory  ===========================
		keymap.set("n", "<leader>fh", function()
			find_files_in_dir("app/helpers")
		end, { desc = "Find files in app/helpers directory" })

		-- =======================  Services Directory  ==========================
		keymap.set("n", "<leader>fs", function()
			find_files_in_dir("app/services")
		end, { desc = "Find files in app/services directory" })

		-- =======================  Lib Directory  ===============================
		keymap.set("n", "<leader>fl", function()
			find_files_in_dir("lib")
		end, { desc = "Find files in lib directory" })

		-- =======================  Spec Directory  ==============================
		keymap.set("n", "<leader>ft", function()
			find_files_in_dir("spec")
		end, { desc = "Find files in spec directory" })

		-- =======================  Config Directory  ============================
		keymap.set("n", "<leader>fC", function()
			find_files_in_dir("config")
		end, { desc = "Find files in config directory" })

		-- =======================  Database Directory  ==========================
		keymap.set("n", "<leader>fD", function()
			find_files_in_dir("db")
		end, { desc = "Find files in db directory" })

		-- =======================  Factories Directory  =========================
		keymap.set("n", "<leader>fF", function()
			find_files_in_dir("spec/factories")
		end, { desc = "Find files in spec/factories directory" })

		-- ======================================================================
		--                          Fuzzy Search By String
		-- ======================================================================

		local function fuzzy_search_word_in_dir(dir)
			require("telescope.builtin").grep_string({
				shorten_path = true,
				word_match = "-w",
				only_sort_text = true,
				search = "",
				search_dirs = dir and { dir } or nil,
				additional_args = function()
					return vim.iter(exclusions):flatten():totable()
				end,
			})
		end

		-- =======================  Fuzzy Current Directory  ==========================
		local function grep_word_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
			fuzzy_search_word_in_dir(current_dir)
		end
		keymap.set("n", "<space>fd", grep_word_in_current_dir, { desc = "Grep word in current directory" })

		-- =======================  Fuzzy Current Working Dir  ========================
		keymap.set("n", "<space>ff", function()
			fuzzy_search_word_in_dir()
		end, { desc = "Search word in current working directory" })

		-- =======================  Fuzzy App Directory  ==============================
		keymap.set("n", "<space>fa", function()
			fuzzy_search_word_in_dir("app")
		end, { desc = "Search word in app directory" })

		-- =======================  Fuzzy Models Directory  ===========================
		keymap.set("n", "<space>fm", function()
			fuzzy_search_word_in_dir("app/models")
		end, { desc = "Search word in app/models directory" })

		-- =======================  Fuzzy Controllers Directory  ======================
		keymap.set("n", "<space>fc", function()
			fuzzy_search_word_in_dir("app/controllers")
		end, { desc = "Search word in app/controllers directory" })

		-- =======================  Fuzzy Views Directory  ============================
		keymap.set("n", "<space>fv", function()
			fuzzy_search_word_in_dir("app/views")
		end, { desc = "Search word in app/views directory" })

		-- =======================  Fuzzy Helpers Directory  ===========================
		keymap.set("n", "<space>fh", function()
			fuzzy_search_word_in_dir("app/helpers")
		end, { desc = "Search word in app/helpers directory" })

		-- =======================  Fuzzy Services Directory  ==========================
		keymap.set("n", "<space>fs", function()
			fuzzy_search_word_in_dir("app/services")
		end, { desc = "Search word in app/services directory" })

		-- =======================  Fuzzy Lib Directory  ===============================
		keymap.set("n", "<space>fl", function()
			fuzzy_search_word_in_dir("lib")
		end, { desc = "Search word in lib directory" })

		-- =======================  Fuzzy Spec Directory  ==============================
		keymap.set("n", "<space>ft", function()
			fuzzy_search_word_in_dir("spec")
		end, { desc = "Search word in spec directory" })

		-- =======================  Fuzzy Config Directory  ============================
		keymap.set("n", "<space>fC", function()
			fuzzy_search_word_in_dir("config")
		end, { desc = "Search word in config directory" })

		-- =======================  Fuzzy Factories Directory  ========================
		keymap.set("n", "<space>fF", function()
			fuzzy_search_word_in_dir("spec/factories")
		end, { desc = "Search word in spec/factories directory" })

		-- ======================================================================
		--                          Word Under Cursor
		-- ======================================================================

		local function grep_word_under_cursor_in_dir(dir)
			local word = vim.fn.expand("<cword>")
			require("telescope.builtin").live_grep({
				search_dirs = { dir },
				default_text = word,
        additional_args = function()
            return exclusions
        end,
			})
		end

		local function grep_word_under_cursor_in_current_dir()
			local current_dir = vim.fn.expand("%:p:h")
			grep_word_under_cursor_in_dir(current_dir)
		end

		-- =======================  Word Under Cursor in Current Directory  ==========================
		keymap.set(
			"n",
			"<leader>sd",
			grep_word_under_cursor_in_current_dir,
			{ desc = "Grep word in current directory" }
		)

		-- =======================  Word Under Cursor in App Directory  ===============================
		keymap.set("n", "<leader>sa", function()
			grep_word_under_cursor_in_dir("app")
		end, { desc = "Grep word in app directory" })

		-- =======================  Word Under Cursor in App Models Directory  ========================
		keymap.set("n", "<leader>sm", function()
			grep_word_under_cursor_in_dir("app/models")
		end, { desc = "Grep word in app/models directory" })

		-- =======================  Word Under Cursor in App Controllers Directory  ====================
		keymap.set("n", "<leader>sc", function()
			grep_word_under_cursor_in_dir("app/controllers")
		end, { desc = "Grep word in app/controllers directory" })

		-- =======================  Word Under Cursor in App Views Directory  ==========================
		keymap.set("n", "<leader>sv", function()
			grep_word_under_cursor_in_dir("app/views")
		end, { desc = "Grep word in app/views directory" })

		-- =======================  Word Under Cursor in App Helpers Directory  ========================
		keymap.set("n", "<leader>sh", function()
			grep_word_under_cursor_in_dir("app/helpers")
		end, { desc = "Grep word in app/helpers directory" })

		-- =======================  Word Under Cursor in App Services Directory  =======================
		keymap.set("n", "<leader>ss", function()
			grep_word_under_cursor_in_dir("app/services")
		end, { desc = "Grep word in app/services directory" })

		-- =======================  Word Under Cursor in Lib Directory  ================================
		keymap.set("n", "<leader>sl", function()
			grep_word_under_cursor_in_dir("lib")
		end, { desc = "Grep word in lib directory" })

		-- =======================  Word Under Cursor in Spec Directory  ===============================
		keymap.set("n", "<leader>st", function()
			grep_word_under_cursor_in_dir("spec")
		end, { desc = "Grep word in spec directory" })

		-- =======================  Word Under Cursor in Config Directory  =============================
		keymap.set("n", "<leader>sC", function()
			grep_word_under_cursor_in_dir("config")
		end, { desc = "Grep word in config directory" })

		-- =======================  Word Under Cursor in Spec Factories Directory  =====================
		keymap.set("n", "<leader>sF", function()
			grep_word_under_cursor_in_dir("spec/factories")
		end, { desc = "Grep word in spec/factories directory" })

		-- ======================================================================
		--                          Exact Word Search
		-- ======================================================================

		-- old
		local function grep_exact_word_in_dir(dir)
			require("telescope").extensions.live_grep_args.live_grep_args({
				search_dirs = { dir },
				initial_query = "",
				path_display = filenameFirst,
				additional_args = function(_)
					return exclusions
					-- return vim.iter(exclusions):flatten():totable()
				end,
			})
		end

		-- ======================= Exact Word in Current File's Directory ======================
		keymap.set("n", "<space>sd", function()
			grep_exact_word_in_dir(vim.fn.expand("%:p:h"))
		end, { desc = "Exact word in the current file's directory" })

		-- ======================= Exact Word in Directory =================================
		keymap.set("n", "<space>aa", function()
			grep_exact_word_in_dir()
		end, { desc = "Exact word in repo" })
		-- ======================= Exact Word in App Directory =================================
		keymap.set("n", "<space>sa", function()
			grep_exact_word_in_dir("app")
		end, { desc = "Exact word in app directory" })

		-- ======================= Exact Word in App/Models Directory ==========================
		keymap.set("n", "<space>sm", function()
			grep_exact_word_in_dir("app/models")
		end, { desc = "Exact word in app/models directory" })

		-- ======================= Exact Word in App/Controllers Directory =====================
		keymap.set("n", "<space>sc", function()
			grep_exact_word_in_dir("app/controllers")
		end, { desc = "Exact word in app/controllers directory" })

		-- ======================= Exact Word in App/Views Directory ===========================
		keymap.set("n", "<space>sv", function()
			grep_exact_word_in_dir("app/views")
		end, { desc = "Exact word in app/views directory" })

		-- ======================= Exact Word in App/Helpers Directory =========================
		keymap.set("n", "<space>sh", function()
			grep_exact_word_in_dir("app/helpers")
		end, { desc = "Exact word in app/helpers directory" })

		-- ======================= Exact Word in App/Services Directory ========================
		keymap.set("n", "<space>ss", function()
			grep_exact_word_in_dir("app/services")
		end, { desc = "Exact word in app/services directory" })

		-- ======================= Exact Word in Lib Directory =================================
		keymap.set("n", "<space>sl", function()
			grep_exact_word_in_dir("lib")
		end, { desc = "Exact word in lib directory" })

		-- ======================= Exact Word in Spec Directory ================================
		keymap.set("n", "<space>st", function()
			grep_exact_word_in_dir("spec")
		end, { desc = "Exact word in spec directory" })

		-- ======================= Exact Word in Config Directory ==============================
		keymap.set("n", "<space>sC", function()
			grep_exact_word_in_dir("config")
		end, { desc = "Exact word in config directory" })

		-- ======================= Exact Word in Spec/Factories Directory ======================
		keymap.set("n", "<space>sF", function()
			grep_exact_word_in_dir("spec/factories")
		end, { desc = "Exact word in spec/factories directory" })
	end,
}
