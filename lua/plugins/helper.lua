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
    keymap = {
      ["g."] = { "actions.toggle_hidden", mode = "n" },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        columns = {
          "icon",
          "permissions",
          "size",
          -- "mtime",
        },
        buf_options = {
          buflisted = true,
          bufhidden = "hide",
        },
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            -- local m = name:match("^%.")
            return false
              -- m ~= nil
          end,
        }
      })
      vim.keymap.set('n', '<leader>pv', "<cmd>Oil<cr>")
      vim.keymap.set('n', '[f', "<cmd>Oil<cr>")
      vim.keymap.set('n', ']f', "<cmd>Oil<cr>")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "oil" },
        callback = function()
          vim.api.nvim_buf_create_user_command(0, "Open", function()
            vim.fn.jobstart("xdg-open " .. string.sub(vim.fn.expand("%:p"), 6)
            )
          end, {})
        end
      })
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
      -- vim.o.sessionoptions = "buffers,curdir,folds,tabpages,localoptions"
      vim.o.sessionoptions = "buffers,curdir,tabpages,localoptions,folds"
    end,
    config = function()
      require("auto-session").setup {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/", "/bin", "/usr/bin", "/@/", "~/Documents", "~/AppImage", "~/Camera" },
        auto_save = true,
        enabled = true,
        lazy_support = false,
        auto_create =  true,
        close_unsupported_windows = true,
        auto_restore_last_session = false,
        use_git_branch = true,
        continue_restore_on_error = true,
        auto_restore = true,
        log_level = "error",
      }
      -- vim.keymap.set("n", '<leader>op', require("auto-session.session-lens").search_session, {
      --   noremap = true,
      -- })

      -- vim.api.nvim_create_autocmd({"VimEnter"}, {
      --   pattern = "*",
      --   callback = function ()
      --     if vim.fn.argv()[1] == '.' then
      --       vim.cmd("SessionRestore")
      --     end
      --   end
      -- })

      -- require("auto-session").AutoRestoreSession
      -- vim.cmd("SessionRestore")
    end
  },
  {
    'mg979/vim-visual-multi',
    -- lazy = false,
  },
  {
    'vimwiki/vimwiki',
    lazy = false
  }
  -- {
  --   'chipsenkbeil/distant.nvim',
  --   branch = 'v0.3',
  --   lazy = false,
  --   config = function()
  --     require('distant'):setup()
  --   end
  -- }
}
