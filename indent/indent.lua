
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function ()
    vim.o.tabstop = 2
  end
})

