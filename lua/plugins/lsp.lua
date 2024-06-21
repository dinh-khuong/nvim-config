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

	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	nmap('<leader>lw', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	nmap('<leader>ls', builtin.lsp_document_symbols, '[F]ind [S]ymbols')
	nmap('<leader>wf', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, '[W]orkspace [L]ist Folders')

	nmap('<leader>lr', vim.lsp.buf.rename, 'Rename references')
	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
		end, { desc = 'Format current buffer with LSP' })
end


return {
	{
		-- lsp configuration & plugins
		'neovim/nvim-lspconfig',
		lazy = false,
		priority = 1,
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'folke/neodev.nvim',
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
			require('neodev').setup({})
			-- require('fidget').setup({ })


			-- local util = require("lspconfig.util")

			local servers = {
				-- clangd = {},
				-- gopls = {},
				pyright = { },
				rust_analyzer = {
					filetypes = "rust",
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
				},
				tsserver = {},
				-- bashls = {},
				lua_ls = {
					Lua = {
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

			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					}
				end,
			}

			-- Diagnostic keymaps
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					client.server_capabilities.semanticTokensProvider = nil
					-- on_attach(ev.client, ev.buf)
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
						-- vim.keymap.set("n", "<C-k>", rt.hover_actions.hover_actions, { buffer = bufnr })
						on_attach(_, bufnr)

						vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<leader>lca", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end
	},
}
