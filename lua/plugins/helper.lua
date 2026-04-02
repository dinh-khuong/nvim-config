return {
  { 'mbbill/undotree', lazy = false },
  { 'tpope/vim-surround', lazy = false },
  { 'kshenoy/vim-signature', lazy = false },
  -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', lazy = false },
  {
    'stevearc/oil.nvim',
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
      'rmagatti/auto-session'
    },
    config = function()
      local oil = require('oil')
      oil.setup {
        default_file_explorer = true,
        columns = {
          'icon',
          'permissions',
          'size',
          "mtime",
        },
        buf_options = {
          buflisted = true,
          bufhidden = 'hide',
        },
        view_options = {
          show_hidden = true,
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'oil' },
        callback = function()
          vim.keymap.set('n', '<C-j>', oil.toggle_hidden)
          -- vim.api.nvim_buf_create_user_command(0, "T", oil.toggle_hidden, {})
        end,
      })
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    -- priority = 100,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    init = function()
      vim.o.sessionoptions = 'buffers,curdir,tabpages,localoptions,folds'
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
        use_git_branch = true,
        continue_restore_on_error = true,
        auto_restore = true,
        log_level = 'error',
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
