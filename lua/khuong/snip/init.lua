local cwDir = vim.fn.stdpath("config") .. "/lua/khuong/snip"
local cwdContent = vim.split(vim.fn.glob(cwDir .. "/*"), '\n', { trimempty = true })

local snipets = {}

for _, value in pairs(cwdContent) do
	local file = vim.split(value, '/', { trimempty = true })
	local filetype = vim.split(file[#file], '.', { plain = true })

	if filetype[1] == "init" then
		goto continue
	end

	table.insert(snipets, {
		filetype = filetype[1],
		used = false,
	})
	::continue::
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		for _, value in pairs(snipets) do
			if vim.bo.filetype == value.filetype and not value.used then
				value.used = true
				require("khuong.snip." .. vim.bo.filetype)
			end
		end
	end
})
