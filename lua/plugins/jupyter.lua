return {
	{
		'dccsillag/magma-nvim',
		lazy = true,
		build = ':UpdateRemotePlugins',
        cmd = { "MagmaInit" },
        config = function ()
            vim.g.magma_image_provider = "kitty"
        end
	},
	{
		'luk400/vim-jukit',
		lazy = true,
		cmd = { "JukitOut", "JukitOutHist" },
		keys = { "<leader>np", "<leader>os", "<leader>hs" },
		commit = "73214c9",
		config = function()
			-- vim.g.jukit_ueberzug_pos_noout = { 0.7, 0.7, 0.4, 0.6 }
			-- vim.g.jukit_hist_use_ueberzug = 1
			vim.g.jukit_terminal = 'tmux'
			-- vim.g.jukit_terminal = 'kitty'
			vim.g.jukit_layout = {
				split = "vertical",
				p1 = 0.3,
				val = {
					'file_content',
					{
						split = "horizontal",
						p1 = 0.3,
						val = { 'output', 'output_history' }
					}
				}
			}

			local kernels = {
				python = "ipython3",
				r = "R",
				lua = "luajit",
				julia = "julia",
				rust = "rust-script"
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = vim.tbl_keys(kernels),
				callback = function(ev)
					local filetype = ev.match
					if kernels[filetype] then
						vim.g.jukit_shell_cmd = kernels[filetype]
					else
						vim.g.jukit_shell_cmd = "ipython3"
					end
				end
			})
		end
	}
}
