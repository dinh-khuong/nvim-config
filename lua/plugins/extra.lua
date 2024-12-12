return {
  { 'tpope/vim-rhubarb', lazy = false, cmd = "GBrowse" },
  -- -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth',  lazy = false },
  -- {
  -- 	"smoka7/multicursors.nvim",
  -- 	event = "VeryLazy",
  -- 	dependencies = {
  -- 		'smoka7/hydra.nvim',
  -- 	},
  -- 	opts = {},
  -- 	cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  -- 	keys = {
  -- 		{
  -- 			mode = { 'v', 'n' },
  -- 			'<Leader>m',
  -- 			'<cmd>MCstart<cr>',
  -- 			desc = 'Create a selection for selected text or word under the cursor',
  -- 		},
  -- 	},
  -- },
  -- {
  -- 	"lervag/vimtex",
  -- 	lazy = false,
  -- 	config = function()
  -- 		-- Use init for configuration, don't use the more common "config".
  -- 	end
  -- },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-w><c-h>",  "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-w><c-j>",  "<cmd>TmuxNavigateDown<cr>" },
      { "<c-w><c-k>",  "<cmd>TmuxNavigateUp<cr>" },
      { "<c-w><c-l>",  "<cmd>TmuxNavigateRight<cr>" },
      { "<c-w><c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  }
}
