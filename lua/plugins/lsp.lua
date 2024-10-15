local on_attach = function(ev, bufnr)
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
	-- nmap('K', vim.lsp.buf.signature_help, 'Signature Documentation')
	nmap('<C-k>', vim.lsp.buf.hover, 'Hover Documentation')

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

	-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
	-- 	command = "Format"
	-- })

	-- Diagnostic keymaps
	nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
	nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
	nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
end


return {
	{
		'folke/neodev.nvim',
		filetypes = "lua",
		config = function()
			require('neodev').setup({})
		end,
	},
	{
		-- lsp configuration & plugins
		'neovim/nvim-lspconfig',
		lazy = false,
		priority = 10,
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

			local servers = {
				basedpyright = {
					basedpyright = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportAny = "none",
								reportUnknownMemberType = "none",
								reportUnknownVariableType = "none",
								reportUnknownArgumentType = "none",
								reportUnknownLambdaType = "none",
								reportMissingTypeStubs = "information",
								reportAttributeAccessIssue = "information",
								reportUnusedExpression = "information",
								reportIndexIssue = "none",
								reportGeneralTypeIssues = "none",
								reportUnusedCallResult = "information",
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

			mason_lspconfig.setup_handlers {
				function(server_name)
					-- local file = io.open("/home/khuong/.config/nvim/test", "a")
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					}
					-- if file then
					-- 	file:write(server_name .. "\n")
					-- 	file:close()
					-- g:netrw_liststyle=end
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
	-- {
	-- 	'mrcjkb/rustaceanvim',
	-- 	version = '^5', -- Recommended
	-- 	lazy = false, -- This plugin is already lazy
	-- 	config = function ()
	-- 		vim.g.rustaceanvim = {
	-- 			-- Plugin configuration
	-- 			tools = {
	-- 			},
	-- 			on_attach = on_attach,
	-- 			-- LSP configuration
	-- 			server = {
	-- 				cmd = function()
	-- 					local mason_registry = require('mason-registry')
	-- 					local ra_binary = mason_registry.is_installed('rust-analyzer')
	-- 					-- This may need to be tweaked, depending on the operating system.
	-- 					and mason_registry.get_package('rust-analyzer'):get_install_path() .. "/rust-analyzer"
	-- 					or "rust-analyzer"

	-- 					return { ra_binary } -- You can add args to the list, such as '--log-file'
	-- 				end,
	-- 				default_settings = {
	-- 					-- rust-analyzer language server configuration
	-- 					['rust-analyzer'] = {
	-- 						imports = {
	-- 							granularity = {
	-- 								group = "module",
	-- 							},
	-- 							prefix = "self",
	-- 						},
	-- 						cargo = {
	-- 							buildScripts = {
	-- 								enable = true,
	-- 							},
	-- 						},
	-- 						procMacro = {
	-- 							enable = true
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			-- DAP configuration
	-- 			dap = {
	-- 			},
	-- 		}
	-- 	end
	-- }
}
