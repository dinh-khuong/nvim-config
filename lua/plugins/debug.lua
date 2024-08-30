-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
return {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    lazy = false,
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',
        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
        'jonboh/nvim-dap-rr',
    },

    config = function()
        local dap = require 'dap'

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                -- 'delve',
            },
        }
        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<leader>dso', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.

        vim.keymap.set('n', '<leader>dp', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>D', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })

        local dapui = require 'dapui'
        vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Debug: See last session result.' })
        vim.keymap.set('n', '<leader>db', dapui.open, { desc = "start a debug ui"})
        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
			--          mappings = {
			-- 	'open' = dapui.open,
			-- },
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶', terminate = '⏹',
                    disconnect = '⏏',
                },
            },
        }

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Install golang specific config
        require('dap-go').setup()
        dap.configurations.rust = { require('nvim-dap-rr').get_rust_config()}
    end,
}
