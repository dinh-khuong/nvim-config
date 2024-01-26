return {
  {
    'mbbill/undotree',
    enabled = true,
    lazy = false,
  },
  {
    'kshenoy/vim-signature',
    enabled = true,
    lazy = false,
  },
  -- detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    enabled = true,
    lazy = false,
  },
  {
    'numToStr/Comment.nvim',
    enabled = true,
    lazy = false,
    config = function()
      require("Comment").setup {
        padding = true,

        sticky = true,
        -- ignore = nil,
        -- extra = nil,
        toggler = {
          line = '<leader>/',
          block = '<leader>bc'
        },

        opleader = {
          line = '<leader>/',
          block = '<leader>bc'
        },

        mappings = {
          basic = true,
          extra = true,
        },
        -- pre_hook = nil,
        -- post_hook = nil,
      }
    end,
  },
}
