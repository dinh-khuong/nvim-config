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
      local files_adapter = require('oil.adapters.files')
      local cache = require('oil.cache')
      local constants = require('oil.constants')
      local util = require('oil.util')
      local uv = vim.uv or vim.loop

      if not files_adapter._khuong_show_current_dir then
        files_adapter._khuong_show_current_dir = true
        local original_list = files_adapter.list
        files_adapter.list = function(url, column_defs, cb)
          local injected_current_dir = false

          original_list(url, column_defs, function(err, entries, fetch_more)
            if not err and entries and not injected_current_dir then
              injected_current_dir = true

              local current_dir = cache.create_entry(url, '.', 'directory')
              local _, path = util.parse_url(url)
              if path then
                current_dir[constants.FIELD_META] = {
                  stat = uv.fs_stat(path),
                }
              end
              table.insert(entries, current_dir)
            end

            cb(err, entries, fetch_more)
          end)
        end
      end

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
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {
      'stevearc/oil.nvim',
      'nvim-telescope/telescope.nvim',
    },
    init = function()
      vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize'
    end,
    config = function()
      local suppressed_dirs = { '~', '~/Projects', '~/Downloads', '/', '/bin', '/usr/bin', '/@/', '~/Documents', '~/AppImage', '~/Camera' }
      require('auto-session').setup {
        suppressed_dirs = suppressed_dirs,
        auto_save = true,
        enabled = true,
        lazy_support = true,
        auto_create = true,
        close_unsupported_windows = true,
        auto_restore_last_session = false,
        use_git_branch = false,
        continue_restore_on_error = true,
        auto_restore = true,
        log_level = 'error',
      }

      vim.api.nvim_create_autocmd({"VimEnter"}, {
        pattern = vim.tbl_map(vim.fn.expand, suppressed_dirs),
        callback = function ()
          vim.schedule(function ()
            vim.cmd("Oil")
          end)
        end
      })
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
    init = function()
      -- vim.g.vimwiki_list = {{
      --   path = '~/vimwiki/',
      --   syntax = 'markdown',
      --   ext = 'md'
      -- }}
      -- vim.g.vimwiki_list = {
      --   {
      --     path = '~/vimwiki/',
      --     syntax = 'default', -- or 'markdown'
      --     ext = '.wiki',
      --     custom_wiki2html = 'vimwiki_markdown', -- (If using markdown)
      --     template_default = 'def_template',
      --     template_ext = '.html',
      --     html_header = 'mathjax' -- CRITICAL: This tells Vimwiki to inject MathJax
      --   }
      -- }
    end,
    lazy = false,
  },
  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    lazy = false,
    config = function()
      require('distant'):setup()
    end
  }
}
