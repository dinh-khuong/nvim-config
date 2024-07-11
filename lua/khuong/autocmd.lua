vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("silent !old-append .")
	end
})

-- fix ident
local Four_Space_Ident = {
	"rust", "python",
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
	})
	vim.api.nvim_set_hl(0, "NormalFloat", {
		bg = "none",
	})
	vim.api.nvim_set_hl(0, "NormalNC", {
		bg = "none",
	})
	vim.api.nvim_set_hl(0, "TelescopeNormal", {
		link = "Normal"
	})
	vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
		link = "Comment"
	})
end

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function ()
-- 		vim.cmd.colorscheme "horizon"
-- 		-- Color()
-- 	end
-- })

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(_ev)
		Color()
	end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "bash-fc.*" },
	callback = function()
		vim.bo.filetype = "sh"
	end
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	callback = function ()
		vim.cmd("setlocal norelativenumber")
		vim.cmd("setlocal nonumber")
	end
})

vim.api.nvim_create_autocmd({"BufWinEnter"}, {
	pattern = { "*.json" },
	callback = function()
		local filename = vim.fn.expand("%")
		local bash_cmd = string.format("stat --printf='%%s' %s", filename)
		local file_size_raw = vim.fn.systemlist(bash_cmd)[1]
		if file_size_raw then
			local file_size = vim.fn.eval(file_size_raw)
			if file_size > 10000 then
				vim.cmd("TSBufDisable highlight")
			end
		end
	end
})
