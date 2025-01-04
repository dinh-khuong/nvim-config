-- require("khuong.helper")

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"-d')

vim.keymap.set({ 'n', 'v' }, 'd', '"_d')
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
-- vim.keymap.set({ 'n', 'v' }, 'p', '"_x')

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "<A-j>", ":move .+<cr>==")
vim.keymap.set("n", "<A-k>", ":move .--<cr>==")

vim.keymap.set("v", "<A-k>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<A-j>", ":move '>+1<cr>gv=gv")

vim.keymap.set("i", "(", "()<left>");
vim.keymap.set("i", "[", "[]<left>");
vim.keymap.set("i", "{", "{}<left>");
vim.keymap.set("i", "\"", "\"\"<left>");

-- vim.keymap.set("t", "<esc>", "<cmd>bp<cr>")
vim.keymap.set("t", "<C-w><C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-w><C-l>", "<C-\\><C-n><C-w><C-l>")
vim.keymap.set("t", "<C-w><C-j>", "<C-\\><C-n><C-w><C-j>")
vim.keymap.set("t", "<C-w><C-k>", "<C-\\><C-n><C-w><C-k>")

-- vim.keymap.set("n", "gc", "gcc")
-- vim.keymap.set("v", "", "gc")

local function dyn_split()
  local winum = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(winum)
  local height = vim.api.nvim_win_get_height(winum)

  local sorted = vim.fn.sort({ width, height })
  local half_max = sorted[1] / 2
  local full_min = sorted[2]
  if half_max > full_min then
    vim.cmd("vertical :split")
  else
    vim.cmd("horizontal :split")
  end
end

vim.keymap.set('n', '<C-w>d', dyn_split, { desc = "Split window dynamically" })

vim.keymap.set('n', '<C-w><C-d>', dyn_split, {
  desc = "Split window dynamically"
})

vim.keymap.set({ 'n', 'v' }, '<leader>q', vim.cmd.bd, { desc = "Quit buffer" })
-- local regex_markdown_path = vim.regex("(/.*)+")

vim.keymap.set('n', '<leader>gx', function()
  local arg = vim.fn.expand("<cWORD>")

  if string.sub(arg, -1) == "@" then -- check symbolic link
    arg = string.sub(arg, 1, -2)
  end

  if vim.bo.filetype == 'markdown' then
    arg = string.sub(arg, 2, -1);
  end

  local path = RealPath(arg)

  if vim.uv.fs_statfs(path) then
    vim.system({ 'xdg-open', path }, { text = false })
  end
end, { desc = "Open default app" });

-- vim.keymap.set("v", "'", [[l:s/\%V\(.*\)\%V/'\1'/ <CR>]], { desc = "Surround selection with '" })
-- vim.keymap.set("v", '"', [[l:s/\%V\(.*\)\%V/"\1"/ <CR>]], { desc = 'Surround selection with "' })
-- vim.keymap.set("v", '<leader><', [[l:s/\%V\(.*\)\%V/<\1>/ <CR>]], { desc = 'Surround selection with <>' })
-- vim.keymap.set("v", "<leader>(", [[l:s/\%V\(.*\)\%V/(\1)/ <CR>]], { desc = "Surround selection with ()" })
-- vim.keymap.set("v", "<leader>{", [[l:s/\%V\(.*\)\%V/{\1}/ <CR>]], { desc = "Surround selection with {}" })
-- vim.keymap.set("v", "<leader>[", [[l:s/\%V\(.*\)\%V/{\1}/ <CR>]], { desc = "Surround selection with []" })
-- vim.keymap.set("v", '*', [[:s/\%V\(.*\)\%V/*\1*/ <CR>]], { desc = "Surround selection with *" })
-- vim.keymap.set("n", '<leader>s*', [[:s/\<<C-r><C-w>\>/*<C-r><C-w>\*/ <CR>]], { desc = "Surround word with *" })
-- vim.keymap.set("n", '<leader>s"', [[:s/\<<C-r><C-w>\>/"<C-r><C-w>\"/ <CR>]], { desc = 'Surround word with "' })
-- vim.keymap.set("n", "<leader>s'", [[:s/\<<C-r><C-w>\>/'<C-r><C-w>\'/ <CR>]], { desc = "Surround word with '" })
