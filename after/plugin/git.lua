local telescope = require("telescope.builtin")

local function nnmap(key, action, desc)
  local newDesc
  if desc ~= nil then
    newDesc = "[G]it " .. desc
  end
  vim.keymap.set('n', key, action, { desc = newDesc });
end

nnmap("<leader>gb", telescope.git_branches, "[B]ranches");
--
nnmap("<leader>gC", telescope.git_commits, "[C]ommit all");
nnmap("<leader>gc", telescope.git_bcommits, "[c]urrent commit"); --
nnmap("<leader>gs", telescope.git_stash, "[s]tash");
nnmap("<leader>gS", telescope.git_status, "[S]atus");

-- merge thing

nnmap("<leader>gM", "<cmd>Gvdiffsplit!<cr>", "[S]atus");
-- config git signs
require('gitsigns').setup {
  signs                        = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol',     -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
    ignore_whitespace = false,
    virt_text_priority = 100,
  }, current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm                         = {
    enable = false
  },
}

-- nnmap("<leader>gd", "<cmd>Gitsigns diffthis<cr>", "[D]iff")
nnmap("<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", "[T]oggle [B]lame")
nnmap("gl", "<cmd>diffget //3<cr>", "[G]et [N]ew")
nnmap("gh", "<cmd>diffget //2<cr>", "[G]et [O]ld")


nnmap("<leader>gp", "<cmd>!git push origin $(git branch --show-current) &<cr>", "[P]ush origin")

