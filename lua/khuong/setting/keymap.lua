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

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "<A-j>", ":move .+<cr>==")
vim.keymap.set("n", "<A-k>", ":move .--<cr>==")

vim.keymap.set("v", "<A-k>", ":move '<-2<cr>gv=gv")
vim.keymap.set("v", "<A-j>", ":move '>+1<cr>gv=gv")

-- vim.keymap.set("t", "<C-v>", "<C-\\><C-n>")

-- vim.keymap.set({ "n" }, "<leader>tn", "<cmd>tabnext<cr>", {
-- 	desc = "Move to next tab",
-- })
--
-- vim.keymap.set({ "n" }, "<leader>tp", "<cmd>tabnext<cr>", {
-- 	desc = "Move to previous tab",
-- })

vim.keymap.set({ "n" }, "<leader>kt", function()
	if vim.opt.keymap == "vietnamese-telex_utf-8" then
		vim.opt.keymap = ""
	else
		vim.opt.keymap = "vietnamese-telex_utf-8"
	end
end, {
	desc = "toggle unikey"
})



vim.keymap.set('n', '<leader>gx', function()
	local arg = vim.fn.expand("<cWORD>")

	if string.sub(arg, -1) == "@" then -- check symbolic link
		arg = string.sub(arg, 1, -2)
	end

	local path = RealPath(arg)
	local file = io.open(path)
	if file then
		file:close()
		os.execute("xdg-open \'" .. path .. "\'")
	end
end, { desc = "Open default app" });
