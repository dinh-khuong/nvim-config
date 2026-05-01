return {
  { 'mbbill/undotree', lazy = false },
  { 'tpope/vim-surround', lazy = false },
  { 'kshenoy/vim-signature', lazy = false },
  -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', lazy = false },
  {
    "refractalize/oil-git-status.nvim",
    lazy = false,
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
  {
    'stevearc/oil.nvim',
    priority = 80,
    lazy = false,
    keys = {
      { '<leader>pv', '<cmd>Oil<cr>', mode = 'n' },
    },
    keymap = {
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
    },
    -- Optional dependencies
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    config = function()
      local oil = require('oil')
      oil.setup {
        default_file_explorer = false,
        columns = {
          'icon',
          'permissions',
          'size',
          "mtime",
        },
        watch_for_changes = true,
        buf_options = {
          buflisted = true,
          bufhidden = 'hide',
        },
        win_options = {
          signcolumn = "yes:2", -- Ensures the signcolumn stays open for symbols
        },
        view_options = {
          show_hidden = true,
        },
      }
      -- for _, hl_group in pairs(require("oil-git-status").highlight_groups) do
      --   if hl_group.index then
      --     vim.api.nvim_set_hl(0, hl_group.hl_group, { fg = "#ff0000" })
      --   else
      --     vim.api.nvim_set_hl(0, hl_group.hl_group, { fg = "#00ff00" })
      --   end
      -- end
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {
      -- 'stevearc/oil.nvim',
      'nvim-telescope/telescope.nvim',
    },
    priority =  120,
    init = function()
      vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize'
    end,
    config = function()
      require('auto-session').setup {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '/bin', '/usr/bin', '/@/', '~/Documents', '~/AppImage', '~/Camera' },
        auto_save = true,
        enabled = true,
        lazy_support = true,
        auto_create = true,
        close_unsupported_windows = true,
        auto_restore_last_session = false,
        use_git_branch = false,
        continue_restore_on_error = false,
        auto_restore = true,
        log_level = 'error',

        bypass_session_save_file_types = { "oil" },
      }
    end,
  },
  {
    dir = "/mnt/new/Documents/code/lua/csscolor.nvim/",
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    'lambdalisue/suda.vim',
    lazy = false,
    config = function ()
      vim.api.nvim_create_user_command("Write", "SudaWrite", {})
      vim.api.nvim_create_user_command("Read", "SudaRead", {})
    end
  },
  {
    'vimwiki/vimwiki',
    lazy = false,
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
