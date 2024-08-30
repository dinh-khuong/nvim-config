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

vim.keymap.set("t", "<esc>", "<cmd>bp<cr>")

-- vim.print(vim.sy(vim.fn.expand("%")))

-- vim.keymap.set("t", "<C-v>", "<C-\\><C-n>")

-- ydotool key 29:1 15:1 15:0 29:0
-- xkjib:us::eng
-- jkm17n:vi:telex
local vietnamese_auto_id = nil;

local on_insert = false;
local function enable_vietnamese()
	vietnamese_auto_id = vim.api.nvim_create_autocmd({"ModeChanged"}, {
		pattern = { "i:n", "n:i", "i:v" },
		callback = function ()
			on_insert = not on_insert
			if on_insert then
				vim.system({'ibus', 'engine', 'm17n:vi:telex' }, { text = false });
			else
				vim.system({'ibus', 'engine', 'xkb:us::eng' }, { text = false });
			end
		end
	})
end

local function disable_vietnamese()
	if vietnamese_auto_id then
		vim.api.nvim_del_autocmd(vietnamese_auto_id)
		vietnamese_auto_id = nil
	end
end

local vietnamese = false
vim.keymap.set({ "n" }, "<leader>kv", function()
	on_insert = false
	vietnamese = not vietnamese
	if vietnamese then
		enable_vietnamese()
	else
		disable_vietnamese()
	end
end, {
	desc = "Toggle Vietnamese unikey"
})

-- vim.opt.keymap = "vietnamese-telex_utf-8"

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

vim.keymap.set('n', '<C-w>d', dyn_split, { desc = "Split window dynamically" })

vim.keymap.set('n', '<C-w><C-d>', dyn_split, {
	desc = "Split window dynamically"
})

-- local regex_markdown_path = vim.regex("(/.*)+")

vim.keymap.set('n', '<leader>gx', function()
	local arg = vim.fn.expand("<cfile>")

	if string.sub(arg, -1) == "@" then -- check symbolic link
		arg = string.sub(arg, 1, -2)
	end

	if vim.bo.filetype == 'markdown' then
		arg = string.sub(arg, 2, -1);
	end

	local path = RealPath(arg)
	if vim.loop.fs_statfs(path) then
		vim.system({'xdg-open', path}, { text=false })
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

