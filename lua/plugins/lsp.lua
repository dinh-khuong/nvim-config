local on_attach = function(_, bufnr)
  local builtin = require('telescope.builtin');
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
  nmap('gt', builtin.lsp_type_definitions, '[G]oto [T]ype [D]efinition')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')

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
    vim.lsp.buf.format({
      bufnr = bufnr,
      async = false,
      -- filter = function(c)
      -- 	return c.id == ev.data.client_id
      -- end,
    })
  end, { desc = 'Format current buffer with LSP' })

  -- Diagnostic keymaps
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
end


return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- lsp configuration & plugins
    'neovim/nvim-lspconfig',
    lazy = false,
    commit = "f4ed656e876e45cf914d7beb972830561178e232",
    -- version = "*",
    priority = 10,
    dependencies = {
      {
        'williamboman/mason.nvim',
        commit = "e2f7f9044ec30067bc11800a9e266664b88cda22"
      },
      {
        'williamboman/mason-lspconfig.nvim',
        commit = "c6c686781f9841d855bf1b926e10aa5e19430a38"
      },
      'folke/neodev.nvim',
      'nvim-telescope/telescope.nvim',
      -- useful status updates for lsp
      -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            view = {
              group_separator_hl = "Normal",
            },
            window = {
              normal_hl = "Keyword",
              -- winbled = 80,
            }
          }
        }
      }, -- additional lua configuration, makes nvim stuff amazing!
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      -- local ruff_lsp  = require('lspconfig.configs').ruff
      -- ruff_lsp.setup()
      local servers = {
        ruff = {
          ruff = {
            init_options = {
              settings = {}
            }
          }
        },
        ['rust_analyzer'] = {
          ['rust_analyzer'] = {
            cargo = {
              allFeatures = true,
              features = { "wasm", "worklet" }
            }
          }
        },
        basedpyright = {
          basedpyright = {
            analysis = {
              diagnosticSeverityOverrides = {
                reportAny = "none",
                reportUnknownMemberType = "none",
                reportUnknownVariableType = "none",
                reportUnknownArgumentType = "none",
                reportUnknownLambdaType = "none",
                reportSelfClsParameterName = "none",
                reportMissingTypeStubs = "none",
                reportMissingTypeArgument = "none",
                reportCallIssue = "info",
                reportArgumentType = "info",
                reportAttributeAccessIssue = "information",
                reportUnusedExpression = "information",
                reportIndexIssue = "none",
                reportGeneralTypeIssues = "none",
                reportUnusedCallResult = "information",
                reportImplicitStringConcatenation = "none",
                reportImplicitRelativeImport = "information",
                reportUninitializedInstanceVariable = "none",
                reportOptionalMemberAccess = "none",
              },
            },
          },
        },
        lua_ls = {
          lua_ls = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      require("lspconfig").dartls.setup({
        cmd = { "dart", "language-server", "--protocol=lsp" },
      })

      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"dart"},
        callback = function (e)
          vim.api.nvim_buf_create_user_command(e.buf, "Format", function ()
            -- local jobid = vim.fn.jobstart({"dart", "format", vim.fn.expand("%")})
            vim.cmd("silent !dart format %")
            vim.cmd("edit")
            end
            , {})
        end
      })

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentHighlightProvider = nil
          end
        end,
      })
    end
  },
}
