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
            ignore_install = {},
            modules = {},
            sync_install = true,
            auto_install = true,
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
    'GCBallesteros/jupytext.nvim',
    init = function()
      vim.g.jupytext_enable = 1
      vim.g.jupytext_command = 'jupytext'
      vim.g.jupytext_fmt = 'py:percent'
    end,
    config = function ()
      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = "oil",
        callback = function (args)
          vim.api.nvim_buf_create_user_command(0, "JupyterFile", function ()
            file_name = vim.fn.input("File: ", "", "file") .. ".ipynb"
            file = io.open(file_name, 'w')
            file:write([[{
 "cells": [],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "name": "python",
   "version": "3.10.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}]])
            file:close()
            vim.cmd("e %")
          end, {})
        end
      })

      require("jupytext").setup {
        custom_language_formatting = {
          python = {
            extension = "md",
            style = "markdown",
            force_ft = "markdown",
          },
      }
      }
    end,
  },
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp = {
        -- `:h events` that cause the diagnostics to update. Set to:
        -- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
        -- but more instant diagnostic updates
        diagnostic_update_events = { "BufWritePost" },
        -- function to find the root dir where the otter-ls is started
        root_dir = function(_, bufnr)
          return vim.fs.root(bufnr or 0, {
            ".git",
            "_quarto.yml",
            "package.json",
            "main.py",
          }) or vim.fn.getcwd(0)
        end,
      },
      -- options related to the otter buffers
      buffers = {
        -- if set to true, the filetype of the otterbuffers will be set.
        -- otherwise only the autocommand of lspconfig that attaches
        -- the language server will be executed without setting the filetype
        --- this setting is deprecated and will default to true in the future
        set_filetype = true,
        -- write <path>.otter.<embedded language extension> files
        -- to disk on save of main buffer.
        -- usefule for some linters that require actual files.
        -- otter files are deleted on quit or main buffer close
        write_to_disk = false,
        -- a table of preambles for each language. The key is the language and the value is a table of strings that will be written to the otter buffer starting on the first line.
        preambles = {},
        -- a table of postambles for each language. The key is the language and the value is a table of strings that will be written to the end of the otter buffer.
        postambles = {},
        -- A table of patterns to ignore for each language. The key is the language and the value is a lua match pattern to ignore.
        -- lua patterns: https://www.lua.org/pil/20.2.html
        ignore_pattern = {
          -- ipython cell magic (lines starting with %) and shell commands (lines starting with !)
          python = "^(%s*[%%!].*)",
        },
      },
      -- remove whitespace from the beginning of the code chunks when writing to the otter buffers
      -- and calculate it back in when handling lsp requests
      handle_leading_whitespace = true,
      -- mapping of filetypes to extensions for those not already included in otter.tools.extensions
      -- e.g. ["bash"] = "sh"
      extensions = {
      },
      -- add event listeners for LSP events for debugging
      debug = false,
      verbose = {         -- set to false to disable all verbose messages
        no_code_found = false -- warn if otter.activate is called, but no injected code was found
      },
    },
  },
  {
    'benlubas/molten-nvim',
    lazy = false,
    build = ':UpdateRemotePlugins',
    dependencies = {
      { '3rd/image.nvim' },
      { 'GCBallesteros/jupytext.nvim' },
      { 'jmbuhr/otter.nvim' },
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
      vim.g.molten_auto_open_output = true
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
        -- vim.keymap.set("n", "<leader>vip")
      end

      local function setup_molten(ev)
        -- local bufn = ev.buf
        set_keymaps()
        require("otter").activate()
        require('molten.status').initialized() -- "Molten" or "" based on initialization information
        require('molten.status').kernels()     -- "kernel1 kernel2" list of kernels attached to buffer or ""
        require('molten.status').all_kernels() -- same as kernels, but will show all kernels
        if string.match(vim.api.nvim_buf_get_name(0), '*.ipynb') then
          vim.cmd('MoltenImportOutput')
        end

        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = '*.ipynb',
          callback = function ()
            vim.cmd("MoltenExportOutput!")
          end
        })
      end

      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = {"markdown"},
      --   callback = function (args)
      --     if string.match(args.file, '*.ipynb$') then
      --       setup_molten()
      --     end
      --   end
      -- })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "MoltenInitPost" },
        callback = setup_molten
      })
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
