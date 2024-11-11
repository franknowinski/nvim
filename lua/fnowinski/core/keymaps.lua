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
keymap.set("n", "<space>q", "<cmd>silent! q<CR>", { desc = "Close window" })
keymap.set("n", "<space>Q", "<cmd>qa!<CR>", { desc = "Quit session" })
keymap.set("n", "<space>b", function()
	vim.cmd("b#")
end, { desc = "Go to previous buffer" })

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

---------------- Copilot Chat Keymaps -------------------
keymap.set("n", "<leader>cm", function()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	end
end, { desc = "CopilotChat - Quick chat" })

-- ---------------- CopilotChat Toggle -------------------
keymap.set("n", "<leader>cc", function()
	require("CopilotChat").toggle() -- Toggle the CopilotChat window
end, { desc = "CopilotChat - Toggle chat" })

keymap.set("v", "<leader>cv", ":'<,'>CopilotChat<CR>", { desc = "CopilotChat - Visual mode" })


keymap.set("v", "<leader>ct", ":'<,'>CopilotChatTests<CR>", { desc = "CopilotChat - Visual mode" })

---------------- CopilotChat  Explain -------------------
keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain" })
keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain" })

---------------- CopilotChat  Fix -------------------
keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat - Fix" })
keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat - Fix" })

--- Dismiss noice messages ---------
keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
