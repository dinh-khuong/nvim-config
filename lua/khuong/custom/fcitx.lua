local fcitx_auto_id = nil;

local on_insert = false;

local function enable_ibus()
	fcitx_auto_id = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		pattern = { "i:nvt", "n:i" },
		callback = function()
			on_insert = not on_insert
			if on_insert then
				vim.system({ 'fcitx5-remote', '-o' }, { text = false });
			else
				vim.system({ 'fcitx5-remote', '-c' }, { text = false });
			end
		end
	})
end

local function disable_ibus()
	if fcitx_auto_id then
		vim.api.nvim_del_autocmd(fcitx_auto_id)
		fcitx_auto_id = nil
	end
end

local fcitx_on = false

vim.api.nvim_create_user_command("Fcitx", function()
	on_insert = false
	fcitx_on = not fcitx_on

	if fcitx_on then
		enable_ibus()
	else
		disable_ibus()
	end
end, {
	desc = "Set fcitx engine",
})
