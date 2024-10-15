return {
	{
		'mbbill/undotree',
		lazy = false,
	},
	{
		'tpope/vim-surround',
		lazy = false,
		config = function()

		end
	},
	{
		'kshenoy/vim-signature',
		lazy = false,
	},
	-- detect tabstop and shiftwidth automatically
	{
		'tpope/vim-sleuth',
		lazy = false,
	},
	{
		'numToStr/Comment.nvim',
		enabled = true,
		lazy = false,
		config = function()
			require("Comment").setup {
				padding = true,
				ignore = "^$",

				sticky = true,
				toggler = {
					line = '',
					block = '<leader>/'

				},
				opleader = {
					line = '',
					block = '<leader>/'
				},

				mappings = {
					basic = true,
					extra = true,
				},
				-- extra = nil,
				-- pre_hook = nil,
				-- post_hook = nil,
			}
            ft = require("Comment.ft")
            ft.set('swayconfig', '#%s')
		end,
	},
	{
		'rmagatti/auto-session',
		lazy = false,
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
		config = function()
			require("auto-session").setup {
				suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
			}
			vim.keymap.set("n", '<leader>op', require("auto-session.session-lens").search_session, {
				noremap = true,
			})
		end
	}
}
