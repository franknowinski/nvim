local api = vim.api

api.nvim_create_augroup("RestoreCursorPosition", { clear = true })

api.nvim_create_autocmd("BufRead", {
	group = "RestoreCursorPosition",
	pattern = "*",
	callback = function()
		if
			vim.bo.filetype ~= "commit"
			and vim.bo.filetype ~= "rebase"
			and vim.fn.line("'\"") > 1
			and vim.fn.line("'\"") <= vim.fn.line("$")
		then
			vim.cmd('normal! g`"')
		end
	end,
})

-- function CopilotChatReviewClear()
--   local ns = vim.api.nvim_create_namespace('copilot_review')
--   vim.diagnostic.reset(ns)
-- end
--
-- vim.api.nvim_create_user_command(
--   'CopilotChatReviewClear',
--   CopilotChatReviewClear,
--   {}
-- )
