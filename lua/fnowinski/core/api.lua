local api = vim.api

api.nvim_create_augroup("RestoreCursorPosition", { clear = true })

api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local cursor_pos = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])  -- or whatever formatting command you're using
    vim.fn.setpos('.', cursor_pos)
  end,
})

api.nvim_create_autocmd("FileType", {
  pattern = "eruby", -- matches .html.erb
  callback = function()
    vim.diagnostic.disable(0) -- disable diagnostics in current buffer
  end,
})
