return {
  -- 1. IMAGE.NVIM
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown", "python" },
            highlight = { enable = true },
            auto_install = true,
          })
        end,
      },
    },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
        neorg = { enabled = true, filetypes = { "norg" } },
        typst = { enabled = true, filetypes = { "typst" } },
      },
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
      hijack_file_patterns = { "*.pdf", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },

  -- 2. JUPYTEXT
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    init = function()
      vim.g.jupytext_enable = 1
      vim.g.jupytext_command = 'jupytext'
      vim.g.jupytext_fmt = 'py:percent'
    end,
    config = function()
      -- Command to create new notebooks from Oil or standard buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function (args)
          vim.api.nvim_create_user_command("JupyterFile", function()
            local py_version = "3.10.0"
            local ok, py_version_cmd = pcall(function() return vim.system({ "python", "--version" }):wait() end)
            if ok and py_version_cmd.stdout then
              py_version = string.sub(py_version_cmd.stdout, 8, -2) -- Strips "Python " and newline
            end

            local file_path_default = string.sub(vim.fn.expand('%:p:h'), 5) .. "/new_file.ipynb"
            local file_path = vim.fn.input("New Notebook Path: ", file_path_default, "file")

            if file_path ~= "" then
              local file = io.open(file_path, 'w')
              if file then
                local json = [[
{
 "cells": [],
 "metadata": {
  "kernelspec": { "display_name": "Python 3", "language": "python", "name": "python3" },
  "language_info": { "name": "python", "version": %q }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}]]
                file:write(string.format(json, py_version))
                file:close()
                print("\nCreated: " .. file_path)
              end
            end
          end, {})
        end
      })

      require("jupytext").setup({
        custom_language_formatting = {
          -- python = { extension = "md", style = "markdown", force_ft = "markdown" },
          python = { extension = "qmd", style = "quarto", force_ft = "quarto" },
          callback = function ()
            require("otter").activate()
          end
        }
      })

      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"quarto"},
        callback = function (_)
          vim.keymap.set("n", "<leader>jn", "o```{python}\n```<esc>O", { buffer = 0 })
        end
      })
    end,
  },

  -- 3. OTTER
  {
    'jmbuhr/otter.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      lsp = { diagnostic_update_events = { "BufWritePost" } },
      buffers = { set_filetype = true, write_to_disk = false },
    },
  },

  -- 4. MOLTEN
  {
    'benlubas/molten-nvim',
    version = "^1.0.0", -- recommended for stability
    build = ':UpdateRemotePlugins',
    -- Use simple strings for dependencies to refer to the configs above
    dependencies = { "3rd/image.nvim", "jmbuhr/otter.nvim" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      -- Keymaps helper
      local function set_molten_keys()
        local opts = { buffer = true, silent = true }
        vim.keymap.set('n', ']f', '<cmd>MoltenNext<cr>zz', opts)
        vim.keymap.set('n', '[f', '<cmd>MoltenPrev<cr>zz', opts)
        vim.keymap.set("n", "<leader><leader>", "<cmd>MoltenReevaluateCell<CR>", opts)
        vim.keymap.set("v", "<leader><leader>", ":<C-u>MoltenEvaluateVisual<CR>gv<esc>", opts)
        vim.keymap.set("n", "<leader>os", "<cmd>noautocmd MoltenEnterOutput<CR>", opts)
        vim.keymap.set("n", "<leader>oh", "<cmd>MoltenHideOutput<CR>", opts)
      end

      -- On Molten Init
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          set_molten_keys()
          if string.find(vim.api.nvim_buf_get_name(0), '%.ipynb$') then
            vim.cmd('MoltenImportOutput')
          end
        end,
      })

      -- Auto-export on save
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = "*.ipynb",
        callback = function()
          if vim.g.molten_kernel_initialized then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })
    end,
  },
}
