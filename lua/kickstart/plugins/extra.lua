return {
	'mbbill/undotree',
	'kshenoy/vim-signature',
	{
		'tpope/vim-fugitive',
		lazy = false,
		cmd = "Git",
	},
	{
		'tpope/vim-rhubarb',
		lazy = false,
		cmd = "GBrowse",
	},
	-- detect tabstop and shiftwidth automatically
	{
		'tpope/vim-sleuth',
		lazy = false,
		enabled = true,
	},
}
