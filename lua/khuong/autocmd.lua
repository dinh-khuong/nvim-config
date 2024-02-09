

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function ()
-- 	end
-- })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("silent !append-old-project .")
	end
})


-- fix ident
local Four_Space_Ident = {
	"rust",
	"sh",
}

local function contain(array, value)
	for index, cvalue in ipairs(array) do
		if cvalue == value then
			return index;
		end
	end
	return nil
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if contain(Four_Space_Ident, vim.bo.filetype) then
			vim.opt.shiftwidth = 4
			vim.opt.tabstop = 4
		else
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
		end
	end,
})

function Color()
	vim.api.nvim_set_hl(0, "Normal", {
		bg = "none",
		-- blend = 10,
	})
	vim.api.nvim_set_hl(0, "NormalNC", {
		bg = "none",
		-- blend = 10,
	})
	vim.api.nvim_set_hl(0, "NormalFloat", {
		bg = "none",
		-- blend = 10,
	})
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		Color()
	end
})
