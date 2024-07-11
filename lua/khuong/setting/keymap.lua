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

vim.keymap.set("i", "(", "()<left>");
vim.keymap.set("i", "[", "[]<left>");
vim.keymap.set("i", "{", "{}<left>");
vim.keymap.set("i", "\"", "\"\"<left>");

vim.keymap.set("t", "<esc>", "<cmd>bp<cr>")

-- vim.keymap.set("t", "<C-v>", "<C-\\><C-n>")

-- vim.keymap.set({ "n" }, "<leader>tn", "<cmd>tabnext<cr>", {
-- 	desc = "Move to next tab",
-- })
--
-- vim.keymap.set({ "n" }, "<leader>tp", "<cmd>tabnext<cr>", {
-- 	desc = "Move to previous tab",
-- })

local vietnamese = false
vim.keymap.set({ "n" }, "<leader>kt", function()
	if vietnamese then
		vietnamese = false
		vim.opt.keymap = ""
	else
		vietnamese = true
		vim.opt.keymap = "vietnamese-telex_utf-8"
	end
end, {
	desc = "toggle unikey"
})

local function dyn_split()
	local winum = vim.api.nvim_get_current_win()
	local width = vim.api.nvim_win_get_width(winum)
	local height = vim.api.nvim_win_get_height(winum)

	local sorted = vim.fn.sort({width, height})
	local half_max = sorted[1] / 2
	local full_min = sorted[2]
	if half_max > full_min then
		vim.cmd("vertical :split")
	else
		vim.cmd("horizontal :split")
	end
end

vim.keymap.set('n', '<C-w>d', dyn_split, {
	desc = "Split window dynamically"
})

vim.keymap.set('n', '<C-w><C-d>', dyn_split, {
	desc = "Split window dynamically"
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

vim.keymap.set("v", "'", [[:s/\%V\(.*\)\%V/'\1'/ <CR>]], { desc = "Surround selection with '" })
vim.keymap.set("v", '"', [[:s/\%V\(.*\)\%V/"\1"/ <CR>]], { desc = 'Surround selection with "' })

vim.keymap.set("v", '<leader><', [[:s/\%V\(.*\)\%V/<\1>/ <CR>]], { desc = 'Surround selection with <>' })
vim.keymap.set("v", "<leader>(", [[:s/\%V\(.*\)\%V/(\1)/ <CR>]], { desc = "Surround selection with ()" })
vim.keymap.set("v", "<leader>{", [[:s/\%V\(.*\)\%V/{\1}/ <CR>]], { desc = "Surround selection with {}" })
vim.keymap.set("v", "<leader>[", [[:s/\%V\(.*\)\%V/{\1}/ <CR>]], { desc = "Surround selection with []" })


-- vim.keymap.set("v", '*', [[:s/\%V\(.*\)\%V/*\1*/ <CR>]], { desc = "Surround selection with *" })

-- vim.keymap.set("n", '<leader>s*', [[:s/\<<C-r><C-w>\>/*<C-r><C-w>\*/ <CR>]], { desc = "Surround word with *" })
-- vim.keymap.set("n", '<leader>s"', [[:s/\<<C-r><C-w>\>/"<C-r><C-w>\"/ <CR>]], { desc = 'Surround word with "' })
-- vim.keymap.set("n", "<leader>s'", [[:s/\<<C-r><C-w>\>/'<C-r><C-w>\'/ <CR>]], { desc = "Surround word with '" })

