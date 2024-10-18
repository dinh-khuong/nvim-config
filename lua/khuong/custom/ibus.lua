-- ydotool key 29:1 15:1 15:0 29:0
-- xkjib:us::eng
-- jkm17n:vi:telex
local ibus_auto_id = nil;

local on_insert = false;

--- @param engine string
local function enable_ibus(engine)
	ibus_auto_id = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		pattern = { "i:n", "n:i", "i:v" },
		callback = function()
			on_insert = not on_insert
			if on_insert then
				vim.system({ 'ibus', 'engine', engine }, { text = false });
			else
				vim.system({ 'ibus', 'engine', 'xkb:us::eng' }, { text = false });
			end
		end
	})
end

local function disable_ibus()
	if ibus_auto_id then
		vim.api.nvim_del_autocmd(ibus_auto_id)
		ibus_auto_id = nil
	end
end

local ibus_on = false

local Ibus_engine = {
	vi = 'm17n:vi:telex',
	en = 'xkb:us::eng',
}

vim.api.nvim_create_user_command("Ibus", function(a)
	local engine = Ibus_engine[a.args]
	if not engine then
		error("Engine not founded")
	end

	on_insert = false
	ibus_on = not ibus_on

	if ibus_on and engine ~= "en" then
		enable_ibus(engine)
	else
		disable_ibus()
	end
end, {
	desc = "Set ibus engine",
	nargs = 1,
	count = 2,
	complete = function()
		return { "vi", "en" }
	end,
})
