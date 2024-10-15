return {
	-- fuzzy finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		-- tag = '0.1.5',
		-- branvim-telescope/telescope-fzf-native.nvim'nch = '0.1.3',
		-- branch = "master",
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		lazy = false,
		priority = 500,
		config = function()
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require('telescope.actions').close,
						},
					},
				},
			}

			-- Enable telescope fzf native, if installed
			pcall(require('telescope').load_extension, 'fzf')

			local function find_git_root()
				local current_file = vim.api.nvim_buf_get_name(0)
				local current_dir
				local cwd = vim.fn.getcwd() -- If the buffer is not associated with a file, return nil
				if current_file == "" then
					current_dir = cwd
				else
					-- Extract the directory from the current file's path
					current_dir = vim.fn.fnamemodify(current_file, ":h")
				end

				if not current_dir then
					return cwd
				end

				-- Find the Git root directory from the current file's path
				local git_root = vim.fn.systemlist("git -C " ..
				vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
				if vim.v.shell_error ~= 0 then
					print("Not a git repository. Searching on current working directory")
					return cwd
				end
				return git_root
			end

			local builtin = require('telescope.builtin')

			-- Custom live_grep function to search in git root
			local function live_grep_git_root()
				local git_root = find_git_root()
				if git_root then
					builtin.live_grep({
						search_dirs = { git_root },
						opts = {
							use_regex = false,
						}
					})
				end
			end

			local function current_grep_git_root()
				local git_root = find_git_root()
				if git_root then
					builtin.grep_string({
						search_dirs = { git_root },
					})
				end
			end

			vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
			vim.api.nvim_create_user_command('CurrentGrepGitRoot', current_grep_git_root, {})

			vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = 'Find recently opened files' })
			vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Find registers' })
			-- builtin.current_buffer_tags

			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffer' })
			-- vim.keymap.set('n', '<leader>ft', require("telescope.actions").select_tab, { desc = '[F]ind [B]uffer' })

			vim.keymap.set('n', '<leader>ff', function()
				if not pcall(builtin.git_files) then
					builtin.find_files()
				end
			end, { desc = '[F]ind [G]it [F]iles' })
			vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = '[F]ind [F]iles' })

			vim.keymap.set({ 'n', 'v' }, '<leader>fw', ':LiveGrepGitRoot<cr>', { desc = '[F]ind by [G]rep on Git Root' })
			vim.keymap.set({ 'n', 'v' }, '<leader>fW', builtin.live_grep, { desc = '[F]ind by [G]rep' })

			vim.keymap.set({ 'n', 'v' }, '<leader>fc', ':CurrentGrepGitRoot<cr>',
				{ desc = '[F]ind current [W]ord in Git' })
			vim.keymap.set({ 'n', 'v' }, '<leader>fC', builtin.grep_string, { desc = '[F]ind [C]urrent word' })

			vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })

			vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = '[F]ind [Treesitter] Symbol' })
			vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = '[F]ind [J]ump list' })
			vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = '[F]ind [M]arks list' })
		end
	},
}
