return {
  {
    'tpope/vim-fugitive',
    lazy = false,
    cmd = "Git",
    config = function()
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

      nnmap("<leader>gm", "<cmd>Gvdiffsplit!<cr>", "[M]erge current file");
      nnmap("gl", "<cmd>diffget //3<cr>", "[G]et [N]ew")
      nnmap("gh", "<cmd>diffget //2<cr>", "[G]et [O]ld")


      nnmap("<leader>gp", "<cmd>!git push origin $(git branch --show-current) &<cr>", "[P]ush origin")
    end
  },
}
