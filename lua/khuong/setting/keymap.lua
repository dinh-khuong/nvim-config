require("khuong.helper")

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- -- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"-d')

vim.keymap.set({ 'n', 'v' }, 'd', '"_d')
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "f", "lf")
vim.keymap.set("n", "F", "hF")
vim.keymap.set("n", "t", "lt")
vim.keymap.set("n", "T", "lT")

vim.keymap.set("n", "<A-j>", ":move .+<cr>==")
vim.keymap.set("n", "<A-k>", ":move .--<cr>==")

vim.keymap.set("v", "<A-k>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<A-j>", ":move '>+1<cr>gv=gv")

vim.keymap.set("t", "<C-l>", "<C-\\><C-n>")

vim.keymap.set('n', '<leader>gx', function()
	vim.cmd.norm("\"vyiW")

	local path = RealPath(vim.fn.getreg("v"))

	-- local file = io.open(path)
	-- if file then
	-- 	file:close()
	os.execute("xdg-open " .. path)
	-- end
end, { desc = "Open default app" });
