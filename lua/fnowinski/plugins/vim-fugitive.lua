return {
  {
    "tpope/vim-fugitive",
    event = "BufRead", 
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitiveblame",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
        end,
      })
    end,
  },
}
