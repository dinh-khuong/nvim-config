return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  lazy = false,
  config = function()
    local bufferline = require('bufferline')

    bufferline.setup {
      highlights = {
        buffer_selected = {
          fg = {
            attribute = "fg",
            highlight = "Keyword",
          },
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
          -- bold = true,
          -- italic = true,
        },
        modified_selected = {
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        close_button_selected = {
          fg = {
            attribute = "fg",
            highlight = "Keyword",
          },
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        separator_selected = {
          fg = {
            attribute = "fg",
            highlight = "Comment"
          },
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        separator_visible = {
          fg = {
            attribute = "fg",
            highlight = "Comment"
          },
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        separator = {
          fg = {
            attribute = "fg",
            highlight = "Comment"
          },
        },
        indicator_visible = {
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        indicator_selected = {
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },

        offset_separator = {
          bg = {
            attribute = "bg",
            highlight = "Visual"
          },
        },
        -- tab_separator = {
        --   fg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        --   bg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        -- },
        -- tab_separator_selected = {
        --   fg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        --   bg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        --   -- sp = '<colour-value-here>',
        --   -- underline = '<colour-value-here>',
        -- },
        -- offset_separator = {
        --   fg = {
        --     attribute = "fg",
        --     highlight = "Keyword",
        --   },
        --   bg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        -- },
        -- fill = {
        --   bg = {
        --     attribute = "bg",
        --     highlight = "Visual"
        --   },
        -- },
      },
      options = {
        -- or you can combine these e.g.
        style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.no_bold
        },
        mode = 'tabs',
        max_name_length=70,
        -- truncate_names = false,
        name_formatter = function(buf)
          local cwd = vim.fn.getcwd()
          -- if string.find(buf.path, "^" .. string.gsub(cwd, "-", "%-")) then
          if string.find(buf.path, cwd, 1, true) == 1 then
            return string.sub(buf.path, #cwd + 2, -1)
          end
          vim.api.nvim_get_hl_id_by_name("BufferLineBuffer")
          -- vim.api.nvim_

          if string.find(buf.path, "oil://", 1, true) == 1 then
            return string.gsub(buf.path, "^oil://" .. os.getenv("HOME"), "oil://~")
          end

          return string.gsub(buf.path, "^" .. os.getenv("HOME"), "~")
        end,
      },
    }

    -- vim.keymap.set({ 'n', 'v' }, '<S-bs>', '<cmd>BufferLineCycleNext<cr>', { desc = "Next Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<bs>', '<cmd>BufferLineCyclePrev<cr>', { desc = "Previous Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<S-	>', '<cmd>BufferLineCyclePrev<cr>', { desc = "Previous Buffer" })

    -- vim.keymap.set({ 'n', 'v' }, '<leader>bb', vim.cmd.BufferLinePick, { desc = "Choose Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bc', vim.cmd.BufferLinePickClose, { desc = "Close Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bsd', vim.cmd.BufferLineSortByRelativeDirectory, { desc = "Sort by directory" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bh', vim.cmd.BufferLineCloseLeft, { desc = "Close all left buffers" })

    -- vim.keymap.set({ 'n', 'v' }, '<leader>bl', vim.cmd.BufferLineCloseRight, { desc = "Close all right buffers" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bse', vim.cmd.BufferLineSortByExtension, { desc = "Sort by extension" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>	', vim.cmd.BufferLineCycleNext, { desc = "Next Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader><BS>', vim.cmd.BufferLineCyclePrev, { desc = "Prev Buffer" })
  end
}
