
-- vim.cmd.colorscheme "retrobox"
vim.cmd.colorscheme "night-owl"

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		vim.inspect(ev)
-- 	end
-- })

-- local kernels = {
-- 	python = "ipython3",
-- 	r = "R",
-- 	lua = "lua",
-- 	julia = "julia",
-- }

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "r", "python", "lua" },
-- 	callback = function(ev)
-- 		local filetype = ev.match
-- 		vim.g.jukit_shell_cmd = kernels[filetype]
-- 	end
-- })
