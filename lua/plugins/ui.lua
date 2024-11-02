return {
  { 'oxfist/night-owl.nvim', lazy = false, },
  -- theme inspired by atom
  { 'navarasu/onedark.nvim', lazy = false, },
  { 'akinsho/horizon.nvim', lazy = false, },
  { 'folke/tokyonight.nvim', lazy = false, },
  {
    -- set lualine as statusline
    'nvim-lualine/lualine.nvim',
    lazy = false,
    -- priority = 1000,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- see `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'}, -- 'FugitiveHead'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {},
    },
  },
  {
    'preservim/nerdtree',
    lazy = true,
    cmd = {"NERDTree"}
  },
  {
    'folke/which-key.nvim',
    lazy = false,
    config = function()
      require('which-key').setup {
        ['<leader>d'] = { name = '[D]edug', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
        ['<leader>bs'] = { name = '[B]uffer [S]ort', _ = 'which_key_ignore' },
        ['<leader>l'] = { name = '[L]sp', _ = 'which_key_ignore' },
        ['<leader>lw'] = { name = '[L]sp [W]orkpace', _ = 'which_key_ignore' },
        ['<leader>lc'] = { name = '[L]sp [C]ode', _ = 'which_key_ignore' },
      }
    end,
  },
}
