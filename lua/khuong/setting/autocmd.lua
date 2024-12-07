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
end

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function ()
-- 		vim.cmd.colorscheme "horizon"
-- 		-- Color()
-- 	end
-- })

vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
  callback = function()
    Color()
  end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "bash-fc.*" },
  callback = function()
    vim.bo.filetype = "sh"
  end
})
