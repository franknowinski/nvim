vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

-- General Keymaps -------------------

-- clear search highlights
keymap.set("n", "<leader><space>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- window management
keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- write and close window
keymap.set("n", "<space>w", "<cmd>w<CR>", { desc = "Write window" })
keymap.set("n", "<space>q", "<cmd>q<CR>", { desc = "Close window" })
keymap.set("n", "<space>Q", "<cmd>qa<CR>", { desc = "Quit session" })
keymap.set("n", "<space>b", ":b#<CR>", { desc = "Go to previous buffer" })

-- keymap for sorting lines in normal mode
keymap.set("n", "<leader>S", ":sort<CR>", { desc = "Sort lines in file" })

-- Insert mode mappings
keymap.set(
	"i",
	"cll",
	"console.log();<Esc>hi",
	{ noremap = true, silent = true, desc = "Insert 'console.log();' and move cursor inside parentheses" }
)
keymap.set("i", "ppp", "binding.pry", { noremap = true, silent = true, desc = "Insert 'binding.pry'" })
keymap.set("i", "dgr", "debugger", { noremap = true, silent = true, desc = "Insert 'debugger'" })
keymap.set("i", "ppb", "<%= binding.pry %>", { noremap = true, silent = true, desc = "Insert '<%= binding.pry %>'" })

-- Normal mode mappings
keymap.set(
	"n",
	"cll",
	"Oconsole.log();<ESC>hi",
	{ noremap = true, silent = true, desc = "Insert 'console.log()' on new line" }
)
keymap.set(
	"n",
	"ppp",
	"Obinding.pry<Esc>",
	{ noremap = true, silent = true, desc = "Insert 'binding.pry' on a new line" }
)
keymap.set("n", "dgr", "Odebugger", { noremap = true, silent = true, desc = "Yank word and insert 'debugger'" })
keymap.set(
	"n",
	"ppb",
	"O<%= binding.pry%>",
	{ noremap = true, silent = true, desc = "Yank word and insert '<%= binding.pry %>'" }
)
