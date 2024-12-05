return {
  { 'mbbill/undotree',       lazy = false, },
  { 'tpope/vim-surround',    lazy = false, },
  { 'kshenoy/vim-signature', lazy = false, },
  -- detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth',      lazy = false, },
  { 'tpope/vim-commentary',  lazy = false, },
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    init = function ()
      vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    config = function()
      require("auto-session").setup {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/", "/bin", "/usr/bin", "/@/" },
      }
      vim.keymap.set("n", '<leader>op', require("auto-session.session-lens").search_session, {
        noremap = true,
      })
    end
  }
}
