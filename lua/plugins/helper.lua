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
		end,
	},
}
