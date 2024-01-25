function Color()
  -- vim.api.nvim_set_hl_ns(1)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    Color()
  end
})

-- require("ibl").setup({})

