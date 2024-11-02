local on_insert_auto_id = nil;
local on_normal_auto_id = nil;

local function enable_ibus()
  on_insert_auto_id = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = { "*:i" },
    callback = function()
      vim.system({ 'fcitx5-remote', '-o' }, { text = false, detach = true });
    end
  })
  on_normal_auto_id = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    pattern = { "i:*" },
    callback = function()
      vim.system({ 'fcitx5-remote', '-c' }, { text = false, detach = true });
    end
  })
end

local function disable_ibus()
  vim.api.nvim_del_autocmd(on_insert_auto_id)
  on_insert_auto_id = nil

  vim.api.nvim_del_autocmd(on_normal_auto_id)
  on_normal_auto_id = nil
end

local fcitx_on = false

vim.api.nvim_create_user_command("Fcitx", function()
  fcitx_on = not fcitx_on

  if fcitx_on then
    enable_ibus()
  else
    disable_ibus()
  end
end, {
    desc = "Set fcitx engine",
  })
