vim.keymap.set("n", "<C-n>", function()
	if not pcall(vim.cmd.cnext) then
		vim.cmd.cfirst()
	end
end)

vim.keymap.set("n", "<C-p>", function()
	if not pcall(vim.cmd.cprevious) then
		vim.cmd.clast()
	end
end)

vim.api.nvim_create_user_command("Search", function(opts)
		vim.cmd.vimgrep(opts.fargs[1] .. " `find . -not -path \'*/\\.*\'`")
	end,
	{
		nargs = 1,
	})

vim.keymap.set("n", "<leader>s", function()
	local input = vim.fn.input "Search: ";
	vim.cmd.vimgrep(input .. " `git ls-files`")
end)
