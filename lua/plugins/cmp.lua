-- "cmp-nvim-lsp": { "branch": "main", "commit": "99290b3ec1322070bcfb9e846450a46f6efa50f0" },
-- "cmp_luasnip": { "branch": "master", "commit": "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },
-- "nvim-cmp": { "branch": "main", "commit": "b555203ce4bd7ff6192e759af3362f9d217e8c89" },
return {
  {
    -- autocompletion
    'hrsh7th/nvim-cmp',
    lazy = false,
    commit = "b555203ce4bd7ff6192e759af3362f9d217e8c89",
    -- version = "*",


    dependencies = {
      -- snippet engine & its associated nvim-cmp source
      {
        'saadparwaiz1/cmp_luasnip',
        commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90",
      },

      "L3MON4D3/LuaSnip",
      -- adds lsp completion capabilities
      {
        'hrsh7th/cmp-nvim-lsp',
        commit = "99290b3ec1322070bcfb9e846450a46f6efa50f0",
      },

      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      -- require('luasnip.loaders.from_vscode').lazy_load()

      -- cmp.register_source

      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end
  },
}
