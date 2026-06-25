vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("silent !old-append .")
  end
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  pattern = { "*.vert", "*.frag" },
  callback = function()
    vim.cmd("set filetype=glsl")
  end
})

function Color()
  vim.api.nvim_set_hl(0, "Normal", {
    bg = "none",
  })
  vim.api.nvim_set_hl(0, "NormalFloat", {
    bg = "none",
  })
  vim.api.nvim_set_hl(0, "NormalNC", {
    bg = "none",
  })
  vim.api.nvim_set_hl(0, "TelescopeNormal", {
    link = "Normal"
  })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
    link = "Comment"
  })

  vim.api.nvim_set_hl(0, "BufferLineTab", {
    fg = "#ffffff",
    bg = "#000000",
  })
  -- vim.api.nvim_set_hl(0, "BufferLineFill", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
  -- vim.api.nvim_set_hl(0, "BufferLineBuffer", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
  -- vim.api.nvim_set_hl(0, "BufferLinePickVisible", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
  -- vim.api.nvim_set_hl(0, "BufferLinePickSelected", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
  -- vim.api.nvim_set_hl(0, "BufferLineBackground", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
  -- vim.api.nvim_set_hl(0, "BufferLineTabSelected", {
  --   fg = "#ffffff",
  --   bg = "#000000",
  -- })
end

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function ()
-- 		vim.cmd.colorscheme "horizon"
-- 		-- Color()
-- 	end
-- })

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = Color
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "bash-fc.*" },
  callback = function()
    vim.bo.filetype = "sh"
  end
})


local cmp_restore_group = vim.api.nvim_create_augroup("RestoreCwdAfterCmp", { clear = true })

vim.keymap.set("i", "<C-x><C-f>", function()
  local current_file = vim.fn.expand("%:p")
  local templates_dir = nil

  if current_file:match("%.html$") or current_file:match("%.jinja$") or current_file:match("%.j2$") then
    templates_dir = current_file:match("^(.*[/\\]templates)")
  elseif current_file:match("%.py$") then
    local current_dir = vim.fn.expand("%:p:h")
    local found = vim.fs.find("templates", { upward = true, path = current_dir, type = "directory" })
    if found and #found > 0 then
      templates_dir = found[1]
    end
  end

  if templates_dir then
    vim.w.saved_cwd = vim.fn.getcwd(0)
    pcall(vim.cmd.lcd, templates_dir)

    vim.api.nvim_create_autocmd({ "CompleteDone", "InsertLeave" }, {
      group = cmp_restore_group,
      once = true,
      callback = function()
        if vim.w.saved_cwd then
          pcall(vim.cmd.lcd, vim.w.saved_cwd)
          vim.w.saved_cwd = nil
        end
      end
    })
  end

  return "<C-x><C-f>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Smart Template Path Completion"
})

