return {
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = function()
      local ls = require "luasnip"
      
      vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })
      require('luasnip.loaders.from_vscode').lazy_load()

    end,
  }
}

