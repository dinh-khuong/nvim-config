return {
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = function()
      local ls = require "luasnip"
      vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })
      require('luasnip.loaders.from_vscode').lazy_load()
      local cwDir = vim.fn.stdpath("config") .. "/lua/khuong/snip"
      local cwdContent = vim.split(vim.fn.glob(cwDir .. "/*"), '\n', { trimempty = true })

      local snipets = {}

      for _, value in pairs(cwdContent) do
        local file = vim.split(value, '/', { trimempty = true })
        local filetype = vim.split(file[#file], '.', { plain = true })

        table.insert(snipets, {
          filetype = filetype[1],
          used = false,
        })
      end

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          for _, value in pairs(snipets) do
            if vim.bo.filetype == value.filetype and not value.used then
              value.used = true
              require("khuong.snip." .. vim.bo.filetype)
            end
          end
        end
      })
    end,
  }
}

