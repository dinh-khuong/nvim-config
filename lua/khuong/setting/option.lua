vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true

vim.o.mouse = 'v'
vim.o.completeopt = 'menuone,noselect'
-- vim.o.completeopt = 'menuone,preview,popup'
vim.opt.inccommand = "split"

vim.o.breakindent = true

vim.o.undofile = true
vim.o.conceallevel = 2

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.termguicolors = false
vim.o.rnu = true
vim.opt.number = true

vim.o.scrolloff = 12
vim.o.laststatus = 3
vim.opt.lz = true

-- vim.o.statusline = "%f"
-- vim.o.winbar = "%f %m"
-- print(vim.fn.expand("%f"))

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "exten"

vim.g.netrw_keepdir = 1
vim.g.netrw_preview = 3
-- vim.g.netrw_fastbrowse = 0
-- vim.b.netrw_col = 3

vim.opt.modeline = true
vim.opt.modelineexpr = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.listchars:append("tab:>.")
vim.opt.listchars:append("extends:-")
vim.opt.listchars:append("nbsp:.")
vim.opt.listchars:append("lead:.")
vim.opt.listchars:append("trail:.")
vim.opt.list = true

vim.g.netrw_browsex_viewer = "xdg-open"
-- vim.g.netrw_rnumb = 1
vim.g.omni_sql_no_default_maps = 0

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.indentexpr = "nvim_treesitter#indent()"
vim.opt.foldlevel = 99

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      timeout = 100,
    })
  end,
  group = highlight_group,
  pattern = '*',
})


-- nvim_get_current_tabpage()
-- tabpg = vim.api.nvim_list_tabpages()
-- vim.print(vim.api.nvim_list_tabpages())

-- vim.api.nvim_set_var
-- vim.api.nvim_set_hl(0, "String", {
-- 	priority = 90
-- });
