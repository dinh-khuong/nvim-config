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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.cmd("set number")
        vim.cmd("set rnu")
    end,
})

-- -- fix ident
-- local Four_Space_Ident = {
-- 	"python", "zig", "rust",
-- }

-- local function contain(array, value)
-- 	for index, cvalue in ipairs(array) do
-- 		if cvalue == value then
-- 			return index;
-- 		end
-- 	end
-- 	return nil
-- end
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function()
-- 		vim.opt.shiftwidth = 0
-- 		if contain(Four_Space_Ident, vim.bo.filetype) then
-- 			vim.opt.tabstop = 4
-- 		else
-- 			vim.opt.tabstop = 2
-- 		end
-- 	end,
-- })

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

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd("setlocal norelativenumber")
        vim.cmd("setlocal nonumber")
    end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    -- pattern = { "*.json" },
    callback = function()
        local filename = vim.fn.expand("%")
        pcall(function()
            local file_stat = vim.uv.fs_stat(filename)
            -- string.format("stat --printf='%%s' %s", filename);
            if file_stat then
                local file_size = file_stat.size
                if file_size > 100000 then
                    vim.cmd("TSBufDisable highlight")
                end
            end
        end)
    end
})
