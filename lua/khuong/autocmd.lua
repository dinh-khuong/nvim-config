vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("silent !old-append .")
	end
})

-- fix ident
local Four_Space_Ident = {
	"rust",
	"c",
	"c++",
	"java",
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
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(ev)
		Color()
		if (ev.match == "horizon") then
			vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
				-- fg = "LightGray"
				fg = "#5D536B"
			})
		end
	end
})
--
--
