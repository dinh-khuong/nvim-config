return {
	{
		-- lsp configuration & plugins
		'neovim/nvim-lspconfig',
		lazy = false,
		dependencies = {
			-- automatically install lsps to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- useful status updates for lsp
			-- note: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', opts = {} }, -- additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
		config = function()
			require('mason').setup()
			require('mason-lspconfig').setup()

			-- require("lspconfig.server_configurations.hydra_lsp")
			local builtin = require('telescope.builtin');

			local on_attach = function(_, bufnr)
				-- NOTE: Remember that lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself
				-- many times.
				--
				-- In this case, we create a function that lets us more easily define mappings specific for LSP related items. It sets the mode, buffer and description for us each time.
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

				-- nmap('gi', vim.lsp.buf.implementation, '[G]oto [D]efinition')
				nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
				nmap('<leader>ls', builtin.lsp_document_symbols, '[F]ind [S]ymbols')

				-- See `:help K` for why this keymap
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				nmap('<leader>lw', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
				-- Lesser used LSP functionality
				-- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				-- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

				nmap('<leader>wf', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				nmap('<leader>lr', vim.lsp.buf.rename, 'Rename references')
				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'Format current buffer with LSP' })
			end
			-- document existing key chains

			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.


			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. They will be passed to
			--  the `settings` field of the server config. You must look up that documentation yourself.
			--
			--  If you want to override the default filetypes that your language server will attach to you can
			--  define the property 'filetypes' to the map in question.

			-- local util = require("lspconfig.util")

			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {
				--   root_dir = util.root_pattern("Cargo.toml"),
				--   rust = {
				--     workspace = { checkThirdParty = false },
				--     telemetry = { enable = false },
				--   },
				-- },
				tsserver = {},
				-- html = { filetypes = { 'html', 'twig', 'hbs'} },

				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			}

			-- Setup neovim lua configuration
			require('neodev').setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				ensure_installed = vim.tbl_keys(servers),
			}

			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
						root_dir = (servers[server_name] or {}).root_dir,
					}
				end,
			}

			-- mason_lspconfig.setup(
			--   -- ensure_installed = ['rust_analyzer'],
			--   ensure_installed=['rust_analyzer'],
			-- })

			-- mason_lspconfig.get_installed_servers

			local nvim_lsp = require 'lspconfig'

			nvim_lsp.rust_analyzer.setup({
				filetypes = "rust",
				-- root_dir = util.root_pattern("Cargo.toml"),
				settings = {
					["rust-analyzer"] = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true
						},
					}
				}
			})

			-- Diagnostic keymaps
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
			-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
					on_attach(ev.client, ev.buf)
				end,
			})
		end
	},
	-- {
	-- 	'rust-lang/rust.vim',
	-- 	ft = "rust",
	-- },
	{
		'simrat39/rust-tools.nvim',
		ft = "rust",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "<C-k>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<leader>lca", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end
	},
}
