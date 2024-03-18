vim.api.nvim_create_autocmd("BufEnter", {
	callback = function ()
		if vim.bo.filetype == "fugitive" then
			vim.keymap.set("n", "<leader>gp", function ()
				local branch = vim.fn.systemlist("git branch --show-current")[1];
				vim.cmd("G push origin " .. branch);
			end, { desc = "push to origin" })
		end
	end
})

vim.api.nvim_create_autocmd("BufLeave", {
	callback = function ()
		if vim.bo.filetype == "fugitive" then
			vim.keymap.del("n", "<leader>gp");
		end
	end
})
