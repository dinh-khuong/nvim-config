return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  lazy = false,
  -- cond = function ()
  --   vim.fn.expand('%')
  --   return true
  -- end,
  config = function()
    require("bufferline").setup {
      options = {
        -- mode = 'tabs',
        mode = 'buffers',
      }
    }

    -- vim.keymap.set({ 'n', 'v' }, '<leader>bb', vim.cmd.BufferLinePick, { desc = "Choose Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bc', vim.cmd.BufferLinePickClose, { desc = "Close Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader>bsd', vim.cmd.BufferLineSortByRelativeDirectory, { desc = "Sort by directory" })
    vim.keymap.set({ 'n', 'v' }, '<leader>bh', vim.cmd.BufferLineCloseLeft, { desc = "Close all left buffers" })
    vim.keymap.set({ 'n', 'v' }, '<leader>bl', vim.cmd.BufferLineCloseRight, { desc = "Close all right buffers" })
    vim.keymap.set({ 'n', 'v' }, '<leader>q', vim.cmd.bd, { desc = "Quit buffer" })

    -- vim.keymap.set({ 'n', 'v' }, '	', vim.cmd.BufferLineCycleNext, { desc = "Next Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<BS>', vim.cmd.BufferLineCyclePrev, { desc = "Previous Buffer" })

    vim.keymap.set({ 'n', 'v' }, '<leader>bse', vim.cmd.BufferLineSortByExtension, { desc = "Sort by extension" })

    -- vim.keymap.set({ 'n', 'v' }, '<leader>	', vim.cmd.BufferLineCycleNext, { desc = "Next Buffer" })
    -- vim.keymap.set({ 'n', 'v' }, '<leader><BS>', vim.cmd.BufferLineCyclePrev, { desc = "Prev Buffer" })
  end
}
