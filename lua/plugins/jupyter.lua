local kernels = {
  python = "ipython3",
  r = "R",
  lua = "luajit",
  julia = "julia",
  rust = "rust-script",
}

return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown" },
            highlight = { enable = true },
          })
        end,
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
    },
  },
  {
    -- 'dccsillag/magma-nvim',
    'benlubas/molten-nvim',
    lazy = false,
    build = ':UpdateRemotePlugins',
    dependencies = {
      { '3rd/image.nvim' }
    },
    -- cmd = { "MagmaInit" },
    init = function()
      vim.g.magma_image_provider = "kitty"
    end,
  },
  {
    'dinh-khuong/vim-jukit',
    lazy = true,
    cmd = { "JukitOut", "JukitOutHist" },
    -- commit = "73214c9",
    -- version = true,
    keys = { "<leader>np" }, --, "<leader>os", "<leader>hs" },
    init = function()
      vim.g.jukit_mappings = 2
      vim.g.jukit_convert_open_detach = 1
      vim.g.jukit_terminal = 'tmux'

      vim.g.jukit_layout = {
        split = "vertical",
        p1 = 0.7,
        val = {
          'file_content',
          {
            split = "horizontal",
            p1 = 0.3,
            val = { 'output', 'output_history' }
          }
        }
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(kernels),
        callback = function(ev)
          local filetype = ev.match
          if kernels[filetype] then
            vim.g.jukit_shell_cmd = kernels[filetype]
          end
        end
      })
    end,
    config = function()
      vim.g.jukit_mappings = 0
      local function set_jukit_keymap()
        vim.keymap.set('n', '<leader>ts', '<cmd>call jukit#splits#term()<cr>', { buffer = true })

        vim.keymap.set("n", '<leader>os', '<cmd>call jukit#splits#output()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>hs', '<cmd>call jukit#splits#history()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>od', '<cmd>call jukit#splits#close_output_split()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>hd', '<cmd>call jukit#splits#close_history()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>ohs', '<cmd>call jukit#splits#output_and_history()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>ah', '<cmd>call jukit#splits#toggle_auto_hist()<cr>', { buffer = true })
        -- vim.keymap.set('n', '<leader>ohd', '<cmd>call jukit#splits#close_output_and_history(1)<cr>', { buffer = true })

        vim.keymap.set('n', '<leader>k', '<cmd>call jukit#splits#out_hist_scroll(0)<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>j', '<cmd>call jukit#splits#out_hist_scroll(1)<cr>', { buffer = true })

        vim.keymap.set('n', ']f', '<cmd>call jukit#cells#jump_to_next_cell()<cr>zz', { buffer = true })
        vim.keymap.set('n', '[f', '<cmd>call jukit#cells#jump_to_previous_cell()<cr>zz', { buffer = true })
        vim.keymap.set('n', '<leader>ck', '<cmd>call jukit#cells#move_up()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>cj', '<cmd>call jukit#cells#move_down()<cr>', { buffer = true })

        vim.keymap.set('n', '<leader><leader>', '<cmd>call jukit#send#section(0)<cr>', { buffer = true })
        -- vim.keymap.set('n', '<cr>', '<cmd>call jukit#send#line()<cr>', { buffer=true })
        -- vim.keymap.set('v', '<cr>', '<cmd>call jukit#send#selection()<cr>', { buffer=true })
        -- local bufn = vim.api.nvim_get_current_buf()
        -- vim.api.nvim_buf_create_user_command(bufn, "JukitCurrent", '<cmd>call jukit#send#until_current_section()<cr>')
        -- vim.api.nvim_buf_create_user_command(bufn, "JukitAll", '<cmd>call jukit#send#all()<cr>')

        vim.keymap.set('n', '<leader>cc', '<cmd>call jukit#send#until_current_section()<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>all', '<cmd>call jukit#send#all()<cr>', { buffer = true })

        -- vim.keymap.set('n', '<leader>sl', '<cmd>call jukit#layouts#set_layout()<cr>', { buffer = true })

        vim.keymap.set('n', '<leader>so', '<cmd>call jukit#splits#show_last_cell_output(1)<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>cs', '<cmd>call jukit#cells#split()<cr>', { buffer = true })

        vim.keymap.set('n', '<leader>co', '<cmd>call jukit#cells#create_below(0)<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>cO', '<cmd>call jukit#cells#create_above(0)<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>ct', '<cmd>call jukit#cells#create_below(1)<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>cT', '<cmd>call jukit#cells#create_above(1)<cr>', { buffer = true })

        -- vim.keymap.set('n', '<leader>cM', '<cmd>call jukit#cells#merge_above()<cr>', { buffer = true })
        -- vim.keymap.set('n', '<leader>cm', '<cmd>call jukit#cells#merge_below()<cr>', { buffer = true })

        -- vim.keymap.set('n', '<leader>ddo', '<cmd>call jukit#cells#delete_outputs(0)<cr>', { buffer = true })
        -- vim.keymap.set('n', '<leader>dda', '<cmd>call jukit#cells#delete_outputs(1)<cr>', { buffer = true })
        -- vim.keymap.set('n', '<leader>cd', '<cmd>call jukit#cells#delete()<cr>', { buffer = true })

        -- view
        vim.keymap.set('n', '<leader>pos', '<cmd>call jukit#ueberzug#set_default_pos()<cr>', { buffer = true })

        -- convert
        vim.keymap.set('n', '<leader>np', '<cmd>call jukit#convert#notebook_convert(g:jukit_notebook_viewer)<cr>',
          { buffer = true })
        vim.keymap.set('n', '<leader>ht', '<cmd>call jukit#convert#save_nb_to_file(0,1,\'html\')<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>pd', '<cmd>call jukit#convert#save_nb_to_file(0,1,\'pdf\')<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>rht', '<cmd>call jukit#convert#save_nb_to_file(1,1,\'html\')<cr>', { buffer = true })
        vim.keymap.set('n', '<leader>rpd', '<cmd>call jukit#convert#save_nb_to_file(1,1,\'pdf\')<cr>', { buffer = true })
      end

      vim.g.jukit_notebook_viewer = 'jupyter-notebook'
      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(kernels),
        callback = function(ev)
          local filetype = ev.match
          if kernels[filetype] then
            set_jukit_keymap()
          end
        end
      })
      set_jukit_keymap()
    end
  }
}
