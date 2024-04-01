return {
	{
		'tpope/vim-rhubarb',
		lazy = false,
		cmd = "GBrowse",
	},
	-- -- detect tabstop and shiftwidth automatically
	{
		'tpope/vim-sleuth',
		lazy = false,
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			'smoka7/hydra.nvim',
		},
		opts = {},
		cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
		keys = {
			{
				mode = { 'v', 'n' },
				'<Leader>m',
				'<cmd>MCstart<cr>',
				desc = 'Create a selection for selected text or word under the cursor',
			},
		},
	},
	{
  "lervag/vimtex",
	lazy = false,
  init = function()
    -- Use init for configuration, don't use the more common "config".
  end
}
}
