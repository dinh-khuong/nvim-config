--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.
Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ
--[[
P.S. You can delete this when you're done too. It's your config now :) ]]
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)

require("khuong")

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- latest stable release lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'mbbill/undotree',
    lazy = false,
  },
  {
    lazy = false,
    'kshenoy/vim-signature',
  },
  {
    'tpope/vim-fugitive',
    lazy = false,
  },
  -- {
  --   'tpope/vim-rhubarb',
  --   lazy = false,
  -- },
  -- detect tabstop and shiftwidth automatically
  -- {
  --   'tpope/vim-sleuth',
  --   lazy = false,
  -- },
  -- note: this is where your plugins related to lsp can be installed.nmac427/guess-indent.nvim
  --  the configuration is done below. search for lspconfig to find it below.
  {
    -- lsp configuration & plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- automatically install lsps to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- useful status updates for lsp
      -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- snippet engine & its associated nvim-cmp source
      'l3mon4d3/luasnip',
      'saadparwaiz1/cmp_luasnip',

      -- adds lsp completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {}
    end,
    opts = {
      -- see `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = 'preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        --
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<ignore>'
        end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<ignore>'
        end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
      end,
    },
  },
  {
    -- theme inspired by atom
    'navarasu/onedark.nvim',
    lazy = false,
  },

  {
    -- set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- see `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  -- fuzzy finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    -- branch = '0.1.3',
    -- branch = "master",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      -- fuzzy finder algorithm which requires local dependencies to be built.
      -- only load if `make` is available. make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- note: if you are having trouble with this installation,
        --       refer to the readme for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
    end
  },
  {
    'simrat39/rust-tools.nvim',
    version = "*",
	lazy = true,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
    end,
  },
  -- {
  --   'LhKipp/nvim-nu',
  --   build = ':TSInstall nu',
  --   config = function()
  --     require 'nu'.setup {}
  --   end,
  -- },
  {
    'rust-lang/rust.vim',
  },
  {
    'nvim-treesitter/playground',
    lazy = false,
  },
  -- { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }
  -- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
  --       these are some example plugins that i've included in the kickstart repository.
  --       uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- note: the import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    you can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    for additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}

require('lazy').setup(plugins, {
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = {
    enabled = true,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = true, -- get a notification when new updates are found
    frequency = 304800, -- check for updates every hour
    check_pinned = false, -- check for pinned packages that can't be updated

  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  },
})
