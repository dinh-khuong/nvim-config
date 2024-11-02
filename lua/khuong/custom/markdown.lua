
vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*.md"},
  callback = function (env)
    vim.keymap.set("n", "gf", function ()
      local path = vim.fn.expand("<cfile>")
      if string.sub(path, 1, 1) == "/" then
        path = vim.fn.getcwd() .. path
      else
        path = RealPath(path)
      end

      vim.cmd.edit(path)
      -- if vim.fn.exists(path) == 1 then
      -- 	vim.cmd.edit(path)
      -- else
      -- 	print(path)
      -- 	-- print("File don't exists")
      -- end

    end, {buffer = env.buf})
  end,
})


