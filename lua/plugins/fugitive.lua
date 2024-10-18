return {
    {
        'tpope/vim-fugitive',
        -- lazy = true,
        cmd = { "G", "Git" },
        version = false,
        config = function()
            local function nnmap(key, action, desc)
                local newDesc
                if desc ~= nil then
                    newDesc = "[G]it " .. desc
                end
                vim.keymap.set('n', key, action, { desc = newDesc });
            end


            -- merge thing
            nnmap("<leader>gm", "<cmd>Gvdiffsplit!<cr>", "[M]erge current file");
            nnmap("gl", "<cmd>diffget //3<cr>", "[G]et [N]ew")
            nnmap("gh", "<cmd>diffget //2<cr>", "[G]et [O]ld")

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "fugitive",
                callback = function (_e)
                    local remote_origin = vim.fn.systemlist("git remote")[1]

                    vim.keymap.set("n", "<leader>gp", function ()
                        local branch = vim.fn.systemlist("git branch --show-current")[1];
                        vim.cmd("G push " .. remote_origin .. " " .. branch);
                    end, { desc = "[G]it push to origin", buffer = 0 })
                end
            })
        end
    },
}
