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
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "oil",
        callback = function(args)
          vim.api.nvim_buf_create_user_command(0, "JupyterFile", function()
            local py_version_cmd = vim.system({ "python", "--version" }):wait()
            local py_version = py_version_cmd.stdout
            if py_version then
              py_version = string.sub(py_version, 7, #py_version-1)
            else
              py_version = "3.10.0"
            end
            file_path_default = string.sub(vim.fn.expand('%:p'), 7) .. "new file.ipynb"
            file_path = vim.fn.input("File: ", file_path_default, "file")
            file = io.open(file_path, 'w')
            file:write(string.format([[
{
 "cells": [],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "name": "python",
   "version": %q 
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}]], py_version
            )
            )
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
      verbose = {             -- set to false to disable all verbose messages
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
      -- vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_cover_empty_lines = false
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      local function set_keymaps()
        vim.keymap.set('n', ']f', '<cmd>MoltenNext<cr>zz', { buffer = true })
        vim.keymap.set('n', '[f', '<cmd>MoltenPrev<cr>zz', { buffer = true })

        vim.keymap.set("n", "<leader>jn", [[o
```python
```<esc>v<up>=o]], { silent = true, desc = "New Cell", buffer = true })

        vim.keymap.set("n", "<leader>jm", "o### <esc>==i", { silent = true, desc = "New Markdown Cell", buffer = true })

        vim.keymap.set("n", "<leader><leader>", ":MoltenReevaluateCell<CR>",
          { silent = true, desc = "re-evaluate cell", buffer = true })
        vim.keymap.set("v", "<leader><leader>", ":<C-u>MoltenEvaluateVisual<CR>gv<esc>",
          { silent = true, desc = "evaluate visual selection", buffer = true })
        vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
          { silent = true, desc = "show/enter output", buffer = true })
        vim.keymap.set("n", "<leader>oh", "<cmd>MoltenHideOutput<CR>",
          { silent = true, desc = "show/enter output", buffer = true })
      end

      local function setup_molten(ev)
        -- local bufn = ev.buf
        set_keymaps()
        require("otter").activate()
        -- require('molten.status').initialized() -- "Molten" or "" based on initialization information
        -- require('molten.status').kernels()     -- "kernel1 kernel2" list of kernels attached to buffer or ""
        -- require('molten.status').all_kernels() -- same as kernels, but will show all kernels
        vim.keymap.set('n', 'K', require("otter").ask_hover, { desc = "Otter Hover" })
        if string.find(vim.api.nvim_buf_get_name(0), '%.ipynb$') then
          vim.cmd('MoltenImportOutput')
        end

        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = "*.ipynb",
          callback = function()
            if require('molten.status').kernels() ~= "" then
              vim.cmd("MoltenExportOutput!")
            end
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = { "MoltenInitPost" },
        callback = setup_molten
      })
    end
  },
}
