vim.o.hlsearch = true
vim.wo.number = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.mouse = 'a'
vim.o.completeopt = 'menuone,noselect'

vim.o.breakindent = true

vim.o.undofile = true

vim.o.conceallevel = 2

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- vim.o.termguicolors = true
vim.o.rnu = true
vim.opt.shiftwidth = 2

vim.o.scrolloff = 12
vim.o.laststatus = 3

vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.omni_sql_no_default_maps = 0

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
	end
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank({
			-- timeout = 1000,
		})
	end,
	group = highlight_group,
	pattern = '*',
})

