return {
  { 'mbbill/undotree', lazy = false },
  { 'tpope/vim-surround', lazy = false },
  { 'kshenoy/vim-signature', lazy = false },
  -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', lazy = false },
  {
    'stevearc/oil.nvim',
    keys = {
      { '<leader>pv', '<cmd>Oil<cr>', mode = 'n' }
    },
    keymap = {
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-tree/nvim-web-devicons', opts = {} } },
    config = function()
      require('oil').setup {
        default_file_explorer = false,
        columns = {
          'icon',
          'permissions',
          'size',
          -- "mtime",
        },
        buf_options = {
          buflisted = true,
          bufhidden = 'hide',
        },
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            return false
          end,
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'oil' },
        callback = function()
          vim.api.nvim_buf_create_user_command(0, 'Open', function()
            vim.fn.execute { vim.g.netrw_browsex_viewer, string.sub(vim.fn.expand '%:p', 6) }
          end, {})
        end,
      })
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    priority = 10,
    -- dependencies = {
    --   'nvim-telescope/telescope.nvim',
    -- },
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
  -- {
  --   'mg979/vim-visual-multi',
  --   -- lazy = false,
  -- },
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
