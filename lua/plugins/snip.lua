return {
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = function()
      local ls = require "luasnip"

      vim.keymap.set({ "i", "s" }, "<c-l>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<c-j>", function() ls.jump(-1) end, { silent = true })
			require('luasnip.loaders.from_vscode').lazy_load()

    end,
  }
}

