local function sNext()
	if not pcall(vim.cmd.cnext) then
		if not pcall(vim.cmd.cfirst) then
			print("not found")
		end
	end
	vim.cmd.norm("zz")
end

local function sPrevious()
	if not pcall(vim.cmd.cprevious) then
		if not pcall(vim.cmd.clast) then
			print("not found")
		end
	end
	vim.cmd.norm("zz")
end

vim.keymap.set("n", "<C-n>", sNext)
vim.keymap.set("n", "<C-p>", sPrevious)

vim.opt.gp = "rg -nf"
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
