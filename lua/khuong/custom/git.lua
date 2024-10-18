
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitive",
    callback = function (_e)
        local remote_origin = vim.fn.systemlist("git remote")[1]

        vim.keymap.set("n", "<leader>gp", function ()
            local branch = vim.fn.systemlist("git branch --show-current")[1];
            vim.cmd("G push " .. remote_origin .. " " .. branch);
        end, { desc = "Git push to origin", buffer = 0 })
    end
})


