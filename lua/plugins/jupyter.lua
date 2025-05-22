local kernels = {
  python = "ipython3",
  r = "R",
  lua = "luajit",
  julia = "julia",
  -- rust = "rust-script",
}

local function index_of(t, value)
  for i, v in ipairs(t) do
    if v == value then
      return i
    end
  end
  return nil
end

local molten_kernels = {}
local files = {}

local function buf_keyfile(buf_name)
  return string.gsub(buf_name, "/", "%%") .. ".json"
end
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
      -- processor = "magick_rock", -- or "magick_cli"
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = true,               -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
        typst = {
          enabled = true,
          filetypes = { "typst" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = 100,
      max_height_window_percentage = 80,
      window_overlap_clear_enabled = true,                                                         -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
      editor_only_render_when_focused = true,                                                      -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true,                                                      -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.pdf", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },
  {
    'benlubas/molten-nvim',
    lazy = false,
    build = ':UpdateRemotePlugins',
    dependencies = {
      { '3rd/image.nvim' }
    },
    cmd = { "MoltenInit", "MoltenLoad" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_image_location = "both"
      vim.g.molten_virt_text_max_lines = 50
      vim.g.molten_open_cmd = vim.g.netrw_browsex_viewer
      -- vim.g.molten_split_size = 60
      vim.g.molten_wrap_output = false
      vim.g.molten_cover_empty_lines = false
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      local function set_keymaps()
        vim.keymap.set('n', ']f', '<cmd>MoltenNext<cr>zz', { buffer = true })
        vim.keymap.set('n', '[f', '<cmd>MoltenPrev<cr>zz', { buffer = true })
        vim.keymap.set("n", "<leader><leader>", ":MoltenReevaluateCell<CR>",
          { silent = true, desc = "re-evaluate cell", buffer = true })
        vim.keymap.set("v", "<leader><leader>", ":<C-u>MoltenEvaluateVisual<CR>gv<esc>",
          { silent = true, desc = "evaluate visual selection", buffer = true })
        vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
          { silent = true, desc = "show/enter output", buffer = true })
        vim.keymap.set("n", "<leader>oh", "<cmd>MoltenHideOutput<CR>",
          { silent = true, desc = "show/enter output", buffer = true })
      end

      local function auto_loaded(bufn)
        local buf_name = vim.api.nvim_buf_get_name(bufn)
        local buf_key = buf_keyfile(buf_name)

        for _, value in pairs(vim.fn.systemlist("ls " .. vim.fn.stdpath('data') .. "/molten")) do
          if buf_key == value and not vim.list_contains(files, value) then
            vim.cmd("silent MoltenLoad")
            return true
          end
        end
        return false
      end

      local function save_buffer(ev)
        local bufn = ev.buf
        local buf = vim.api.nvim_buf_get_name(bufn)
        local kernel_id = ev.data.kernel_id

        local new_buffer = {
          key = buf_keyfile(buf),
          name = buf,
        }

        table.insert(files, new_buffer['key'])
        if molten_kernels[kernel_id] == nil then
          molten_kernels[kernel_id] = { new_buffer }
        else
          table.insert(molten_kernels[kernel_id], new_buffer)
        end

        set_keymaps()
      end

      vim.api.nvim_create_user_command("MInit", function()
        local bufn = vim.api.nvim_get_current_buf();
        if not auto_loaded(bufn) then
          vim.cmd("silent MoltenInit")
        end

        set_keymaps()
      end, {})

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function(ev)
          local bufn = ev.buf
          auto_loaded(bufn)
        end
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "MoltenInitPost" },
        callback = save_buffer,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "MoltenDeinitPre" },
        callback = function(ev)
          -- local file = io.open('kernel_id.txt', 'a')
          local current_kernel_id = ev.data.kernel_id
          -- file:write(vim.inspect(ev))

          for _, value in ipairs(molten_kernels[current_kernel_id]) do
            vim.cmd("e " .. value.name)
            local remove_index = index_of(files, value.key)
            if remove_index then
              table.remove(files, remove_index)
            end
            vim.cmd("silent MoltenSave")
          end
          molten_kernels[current_kernel_id] = {}
        end
      })

      -- vim.api.nvim_create_autocmd("ExitPre", {
      --   callback = function (_)
      --     for _, _ in pairs(molten_kernels) do
      --       vim.cmd("silent MoltenDeinit")
      --     end
      --   end
      -- })
    end
  },
  -- {
  --   'dinh-khuong/vim-jukit',
  --   lazy = true,
  --   cmd = { "JukitOut", "JukitOutHist" },
  --   -- commit = "73214c9",
  --   -- version = true,
  --   keys = { "<leader>np" }, --, "<leader>os", "<leader>hs" },
  --   init = function()
  --     vim.g.jukit_mappings = 2
  --     vim.g.jukit_convert_open_detach = 1
  --     vim.g.jukit_terminal = 'tmux'
  --
  --     vim.g.jukit_layout = {
  --       split = "vertical",
  --       p1 = 0.7,
  --       val = {
  --         'file_content',
  --         {
  --           split = "horizontal",
  --           p1 = 0.3,
  --           val = { 'output', 'output_history' }
  --         }
  --       }
  --     }
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = vim.tbl_keys(kernels),
  --       callback = function(ev)
  --         local filetype = ev.match
  --         if kernels[filetype] then
  --           vim.g.jukit_shell_cmd = kernels[filetype]
  --         end
  --       end
  --     })
  --   end,
  --   config = function()
  --     vim.g.jukit_mappings = 0
  --     local function set_jukit_keymap()
  --       vim.keymap.set('n', '<leader>ts', '<cmd>call jukit#splits#term()<cr>', { buffer = true })
  --
  --       vim.keymap.set("n", '<leader>os', '<cmd>call jukit#splits#output()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>hs', '<cmd>call jukit#splits#history()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>od', '<cmd>call jukit#splits#close_output_split()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>hd', '<cmd>call jukit#splits#close_history()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>ohs', '<cmd>call jukit#splits#output_and_history()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>ah', '<cmd>call jukit#splits#toggle_auto_hist()<cr>', { buffer = true })
  --       -- vim.keymap.set('n', '<leader>ohd', '<cmd>call jukit#splits#close_output_and_history(1)<cr>', { buffer = true })
  --
  --       vim.keymap.set('n', '<leader>k', '<cmd>call jukit#splits#out_hist_scroll(0)<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>j', '<cmd>call jukit#splits#out_hist_scroll(1)<cr>', { buffer = true })
  --
  --       vim.keymap.set('n', ']f', '<cmd>call jukit#cells#jump_to_next_cell()<cr>zz', { buffer = true })
  --       vim.keymap.set('n', '[f', '<cmd>call jukit#cells#jump_to_previous_cell()<cr>zz', { buffer = true })
  --       vim.keymap.set('n', '<leader>ck', '<cmd>call jukit#cells#move_up()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>cj', '<cmd>call jukit#cells#move_down()<cr>', { buffer = true })
  --
  --       vim.keymap.set('n', '<leader><leader>', '<cmd>call jukit#send#section(0)<cr>', { buffer = true })
  --       -- vim.keymap.set('n', '<cr>', '<cmd>call jukit#send#line()<cr>', { buffer=true })
  --       -- vim.keymap.set('v', '<cr>', '<cmd>call jukit#send#selection()<cr>', { buffer=true })
  --       -- local bufn = vim.api.nvim_get_current_buf()
  --       -- vim.api.nvim_buf_create_user_command(bufn, "JukitCurrent", '<cmd>call jukit#send#until_current_section()<cr>')
  --       -- vim.api.nvim_buf_create_user_command(bufn, "JukitAll", '<cmd>call jukit#send#all()<cr>')
  --
  --       vim.keymap.set('n', '<leader>cc', '<cmd>call jukit#send#until_current_section()<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>all', '<cmd>call jukit#send#all()<cr>', { buffer = true })
  --
  --       -- vim.keymap.set('n', '<leader>sl', '<cmd>call jukit#layouts#set_layout()<cr>', { buffer = true })
  --
  --       vim.keymap.set('n', '<leader>so', '<cmd>call jukit#splits#show_last_cell_output(1)<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>cs', '<cmd>call jukit#cells#split()<cr>', { buffer = true })
  --
  --       vim.keymap.set('n', '<leader>co', '<cmd>call jukit#cells#create_below(0)<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>cO', '<cmd>call jukit#cells#create_above(0)<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>ct', '<cmd>call jukit#cells#create_below(1)<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>cT', '<cmd>call jukit#cells#create_above(1)<cr>', { buffer = true })
  --
  --       -- vim.keymap.set('n', '<leader>cM', '<cmd>call jukit#cells#merge_above()<cr>', { buffer = true })
  --       -- vim.keymap.set('n', '<leader>cm', '<cmd>call jukit#cells#merge_below()<cr>', { buffer = true })
  --
  --       -- vim.keymap.set('n', '<leader>ddo', '<cmd>call jukit#cells#delete_outputs(0)<cr>', { buffer = true })
  --       -- vim.keymap.set('n', '<leader>dda', '<cmd>call jukit#cells#delete_outputs(1)<cr>', { buffer = true })
  --       -- vim.keymap.set('n', '<leader>cd', '<cmd>call jukit#cells#delete()<cr>', { buffer = true })
  --
  --       -- view
  --       vim.keymap.set('n', '<leader>pos', '<cmd>call jukit#ueberzug#set_default_pos()<cr>', { buffer = true })
  --
  --       -- convert
  --       vim.keymap.set('n', '<leader>np', '<cmd>call jukit#convert#notebook_convert(g:jukit_notebook_viewer)<cr>',
  --         { buffer = true })
  --       vim.keymap.set('n', '<leader>ht', '<cmd>call jukit#convert#save_nb_to_file(0,1,\'html\')<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>pd', '<cmd>call jukit#convert#save_nb_to_file(0,1,\'pdf\')<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>rht', '<cmd>call jukit#convert#save_nb_to_file(1,1,\'html\')<cr>', { buffer = true })
  --       vim.keymap.set('n', '<leader>rpd', '<cmd>call jukit#convert#save_nb_to_file(1,1,\'pdf\')<cr>', { buffer = true })
  --     end
  --
  --     vim.g.jukit_notebook_viewer = 'jupyter-notebook'
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = vim.tbl_keys(kernels),
  --       callback = function(ev)
  --         local filetype = ev.match
  --         if kernels[filetype] then
  --           set_jukit_keymap()
  --         end
  --       end
  --     })
  --     set_jukit_keymap()
  --   end
  -- }
}
