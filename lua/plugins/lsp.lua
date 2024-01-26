return {
	{
		-- lsp configuration & plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- automatically install lsps to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- useful status updates for lsp
			-- note: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', opts = {} }, -- additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},
	{
		-- autocompletion
		'hrsh7th/nvim-cmp',
		lazy = false,
		dependencies = {
			-- snippet engine & its associated nvim-cmp source
			'l3mon4d3/luasnip',
			'saadparwaiz1/cmp_luasnip',

			-- adds lsp completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},
	{
		'rust-lang/rust.vim',
		ft = "rust",
	},
	{
		'simrat39/rust-tools.nvim',
		ft = "rust",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "<C-k>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<leader>lca", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end
	},
}
