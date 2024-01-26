function sNext()
	if not pcall(vim.cmd.cnext) then
		vim.cmd.cfirst()
	end
end

function sPrevious()
	if not pcall(vim.cmd.cprevious) then
		vim.cmd.clast()
	end
end

vim.keymap.set("n", "<C-n>", "<cmd>lua sNext()<cr>zz")
vim.keymap.set("n", "<C-p>", "<cmd>lua sPrevious()<cr>zz")

vim.opt.gp = "rg -ne"
vim.opt.hidden = true

vim.api.nvim_create_user_command("Grep", function(opts)
	vim.cmd("silent grep '" .. opts.fargs[1] .. "'") -- ..  " `find . -not -path \'*/\\.*\'`")
end, {
	nargs = 1,
})

vim.api.nvim_create_user_command("VimGrep", function(opts)
	vim.cmd.vimgrep(opts.fargs[1] .. " `git ls-files`")
	-- ..  " `find . -not -path \'*/\\.*\'`")
end, {
	nargs = 1,
})

vim.api.nvim_create_user_command("Argdo", function(opts)
	vim.cmd("silent! argdo if &ma | " .. opts.fargs[1] .. " | endif")
end, {
	nargs = 1,
})

vim.keymap.set("n", "<leader>s", function()
	local input = vim.fn.input "Git Search: "
	vim.cmd("Grep " .. input) -- .. " `git ls-files`")
end)