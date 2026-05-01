local on_attach = function(_, bufnr)
  local builtin = require 'telescope.builtin'
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    -- vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    vim.keymap.set('n', keys, func, { desc = desc })
  end

  -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  nmap('<leader>gt', builtin.lsp_type_definitions, '[G]oto [T]ype [D]efinition')
  nmap('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>gr', builtin.lsp_references, '[G]oto [R]eferences')

  -- nmap('', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('K', vim.lsp.buf.hover, 'Signature Documentation')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  nmap('<leader>lw', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('<leader>ls', builtin.lsp_document_symbols, '[F]ind [S]ymbols')

  nmap('<leader>wf', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  nmap('<leader>lr', vim.lsp.buf.rename, 'Rename references')
  -- vim.print(ev)

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format {
      bufnr = bufnr,
      async = false,
      -- filter = function(c)
      -- 	return c.id == ev.data.client_id
      -- end,
    }
  end, { desc = 'Format current buffer with LSP' })

  -- Diagnostic keymaps
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
end

return {
  {
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {
        library = {
          'williamboman/mason.nvim',
          -- See the configuration section for more details
          -- "lazy.nvim",
          -- It can also be a table with trigger words / mods
          -- Only load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          -- always load the LazyVim library
          -- "LazyVim",
          -- Only load the lazyvim library when the `LazyVim` global is found
          -- { path = "LazyVim", words = { "LazyVim" } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `DrKJeff16/wezterm-types` to be installed
          -- { path = "wezterm-types", mods = { "wezterm" } },
          -- Load the xmake types when opening file named `xmake.lua`
          -- Needs `LelouchHe/xmake-luals-addon` to be installed
          -- { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
      },
      -- enabled = function(root_dir)
      --   return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
      -- end,
    },
  },
  {
    -- lsp configuration & plugins
    'williamboman/mason.nvim',
    lazy = false,
    version = '*',
    dependencies = {
      'neovim/nvim-lspconfig',
      {
        'williamboman/mason-lspconfig.nvim',
      },
      -- 'folke/neodev.nvim',
      'nvim-telescope/telescope.nvim',
      -- useful status updates for lsp
      -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            view = {
              group_separator_hl = 'Normal',
            },
            window = {
              normal_hl = 'Keyword',
              -- winbled = 80,
            },
          },
        },
      }, -- additional lua configuration, makes nvim stuff amazing!
    },
    config = function()
      require('mason').setup()
      -- require('mason-lspconfig').setup()

      local servers = {
        ruff = {
          settings = {},
        },
        ['rust_analyzer'] = {
          cargo = {
            allFeatures = true,
            features = { 'wasm', 'worklet' },
          },
        },
        basedpyright = {
          -- Native API needs to know exactly how to start the server
          -- cmd = { 'basedpyright-langserver', '--stdio' },
          -- filetypes = { 'python' },
          -- root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportAny = 'none',
                  reportUnknownMemberType = 'none',
                  -- ... (add the rest of your overrides here) ...
                },
              }
            }
          },
        },
        tailwindcss = {
          filetypes = { "html", "htmldjango", "css", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" },
          settings = {
            tailwindCSS = {
              files = {
                exclude = { "**/.git/**", "**/node_modules/**", "**/*.scss" },
              },
            },
          },
        },
        lua_ls = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- local file = io.open('text.txt', 'a')
      -- file:write(vim.inspect(capabilities))
      -- file:close()

      local manson_config = require 'mason-lspconfig'
      local configed_servers = vim.tbl_keys(servers)

      for _, server in pairs(manson_config.get_installed_servers()) do
        if vim.tbl_contains(configed_servers, server) then
          -- Grab the whole configuration object for this server
          local server_opts = servers[server]
          -- Inject the capabilities
          server_opts.capabilities = capabilities

          -- Pass the combined object to the native API
          vim.lsp.config(server, server_opts)
        else
          vim.lsp.config(server, {
            capabilities = capabilities,
          })
        end
      end

      vim.lsp.config('glint', {
        cmd = { 'glint-language-server' },
      })
      vim.lsp.enable { 'glint' }

      vim.lsp.enable(manson_config.get_installed_servers())

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          on_attach(ev, ev.buf)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
          -- if client then
          --   client.server_capabilities.semanticTokensProvider = nil
          --   client.server_capabilities.documentHighlightProvider = nil
          -- end
        end,
      })
    end,
  },
}
