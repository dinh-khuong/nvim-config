return {
  -- {
  -- 	'nvim-treesitter/nvim-treesitter-context',
  -- 	config = function()
  -- 		require 'treesitter-context'.setup {
  -- 			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  -- 			max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
  -- 			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  -- 			line_numbers = true,
  -- 			multiline_threshold = 20, -- Maximum number of lines to show for a single context
  -- 			trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  -- 			mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- 			-- Separator between context and content. Should be a single character string, like '-'.
  -- 			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  -- 			separator = nil,
  -- 			zindex = 20, -- The Z-index of the context window
  -- 			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  -- 		}
  -- 	end,
  -- 	lazy = false,
  -- },
  {
    -- highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dependencies = {
      priority = 20,
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ft = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'css', 'html', 'java', 'zig', 'markdown', 'glsl' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      -- local disable_langs = { 'tmux', 'dockerfile', 'hypr', 'r', 'json' }

      -- vim.env.PATH
      -- vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
      --   callback = function(env)
      --     local filename = env.match
      --     local filetype = filename:match("%.([^%.]+)$")

      --     if vim.list_contains(disable_langs, filetype) then
      --       return
      --     end
      --     local file_stat = vim.uv.fs_stat(filename)
      --     if file_stat then
      --       local file_size = file_stat.size
      --       if file_size > 10 then
      --         vim.treesitter.stop(env.bufnr)
      --       end
      --     end
      --   end
      -- })

      -- vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
      --   callback = function(env)
      --     local filename = env.file
      --     local file_stat = vim.uv.fs_stat(filename)
      --     if file_stat then
      --       local file_size = file_stat.size
      --       if file_size < 100000 then
      --         vim.treesitter.stop(env.bufn)
      --         vim.cmd("TSBufDisable highlight")
      --         -- vim.treesitter.start()
      --       end
      --     end
      --   end
      -- })

      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          -- Add languages to be installed here that you want installed for treesitter
          ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'css', 'html', 'java', 'zig', 'markdown', 'glsl' },
          ignore_install = { 'tmux', 'dockerfile', 'hypr', 'r', 'tsv', 'csv', 'json' },
          -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
          auto_install = true,
          modules = {},
          sync_install = false,
          highlight = {
            enable = true,
            -- disable = { 'tmux', 'dockerfile', 'hypr', 'r', 'tsv', 'csv', 'json' },
            -- disable = function(lang, bufnr)
            --   local langs = { 'tmux', 'dockerfile', 'hypr', 'r' }
            --   local filename = vim.api.nvim_buf_get_name(bufnr)
            --   local file_stat = vim.uv.fs_stat(filename)
            --   if file_stat then
            --     local file_size = file_stat.size
            --     if file_size > 100000 then
            --       vim.treesitter.stop(bufnr)
            --       return true
            --     end
            --   end
            --   return vim.list_contains(langs, lang) or vim.api.nvim_buf_line_count(bufnr) > 50000
            -- end,
          },
          additional_vim_regex_highlighting = true,
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<c-space>',
              node_incremental = '<c-space>',
              scope_incremental = '<c-s>',
              node_decremental = '<M-space>',
            },
          },
          textobjects = {
            swap = {
              enable = true,
              swap_previous = {
                ['<leader>A'] = '@parameter.inner',
              },
              swap_next = {
                ['<leader>a'] = '@parameter.inner',
              },
            },
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']]'] = '@function.outer',
                [']m'] = '@class.outer',
              },
              goto_next_end = {
                [']['] = '@function.outer',
                [']M'] = '@class.outer',
              },
              goto_previous_start = {
                ['[['] = '@function.outer',
                ['[m'] = '@class.outer',
              },
              goto_previous_end = {
                ['[]'] = '@function.outer',
                ['[M'] = '@class.outer',
              },
            },
          },
        }
      end, 0)
    end
  },
  {
    "theRealCarneiro/hyprland-vim-syntax",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "hypr",
  },
}
