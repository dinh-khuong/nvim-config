-- require("night-owl").setup()

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function ()
		vim.cmd.colorscheme "horizon"
	end
})
-- vim.cmd.colorscheme("night-owl")

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		vim.inspect(ev)
-- 	end
-- })
