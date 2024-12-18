return {
  { 'mbbill/undotree',       lazy = false, },
  { 'tpope/vim-surround',    lazy = false, },
  { 'kshenoy/vim-signature', lazy = false, },
  -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth',      lazy = false, },
  -- { 'tpope/vim-commentary',  lazy = false, },
  {
    'stevearc/oil.nvim',
    priority = 100,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    lazy = false,
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function ()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          -- "name",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        buf_options = {
          buflisted = true,
          bufhidden = "hide",
        },
      })
      vim.keymap.set('n', '<leader>pv', "<cmd>Oil<cr>")
    end
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    priority = 90,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    init = function()
      vim.o.sessionoptions = "folds,blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    config = function()
      require("auto-session").setup {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/", "/bin", "/usr/bin", "/@/", "~/Documents", "~/AppImage", "~/Camera" },
      }
      vim.keymap.set("n", '<leader>op', require("auto-session.session-lens").search_session, {
        noremap = true,
      })
      vim.cmd("SessionRestore")
    end
  },
  {
    'mg979/vim-visual-multi',
    -- lazy = false,
  },
  -- {
  --   'chipsenkbeil/distant.nvim',
  --   branch = 'v0.3',
  --   lazy = false,
  --   config = function()
  --     require('distant'):setup()
  --   end
  -- }
}
