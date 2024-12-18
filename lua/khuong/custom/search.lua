

vim.api.nvim_create_user_command('CNext', function ()
  if not pcall(vim.cmd.cnext) then
    if not pcall(vim.cmd.cfirst) then
      print("not found")
    end
  end
end, { desc = "Next Search" })

vim.api.nvim_create_user_command('CPrevious', function ()
  if not pcall(vim.cmd.cprevious) then
    if not pcall(vim.cmd.clast) then
      print("not found")
    end
  end
end, { desc = "Previous Search" })

vim.keymap.set("n", "<A-n>", "<cmd>CNext<cr>zz")
vim.keymap.set("n", "<A-p>", "<cmd>CPrevious<cr>zz")

vim.opt.gp = "rg -n"

vim.api.nvim_create_user_command("Grep", function(opts)
  vim.cmd("silent grep -F -U '" .. opts.fargs[1] .. "'")
end, {
    nargs = 1,
  })

vim.api.nvim_create_user_command("VimGrep", function(opts)
  vim.cmd.vimgrep(opts.fargs[1] .. " `git ls-files`")
end, {
    nargs = 1,
  })

vim.api.nvim_create_user_command("Argdo", function(opts)
  vim.cmd("silent! argdo if &ma | " .. opts.fargs[1] .. " | endif")
end, {
    nargs = 1,
  })

-- vim.keymap.set("n", "<leader>s", function()
-- 	local input = vim.fn.input "Git Search: "
-- 	vim.cmd("Grep " .. input) -- .. " `git ls-files`")
-- end)
