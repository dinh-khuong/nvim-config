-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior
return {
  'neovim/nvim-lspconfig',
  config = function()
    local format_is_enabled = true
    vim.api.nvim_create_user_command('FormatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Tsserver usually works poorly. Sorry you work with bad languages
        -- You can remove this line if you know what you're doing :)
        -- if client.name == 'tsserver' then
        --   return
        -- end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        -- vim.api.nvim_create_autocmd('BufWritePre', {
        --   group = get_augroup(client),
        --   buffer = bufnr,
        --   callback = function()
        --     if not format_is_enabled then
        --       return
        --     end
        --
        --     vim.lsp.buf.format {
        --       async = false,
        --       filter = function(c)
        --         return c.id == client.id
        --       end,
        --     }
        --   end,
        -- })
      end,
    })
  end,
}
