return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      -- "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- 'jonboh/nvim-dap-rr',
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()
      -- require("dap-go").setup()

      dap.adapters.codelldb = {
        type = 'executable',
        command = 'codelldb'
      }

      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch",
          program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
          args = {},
        },
      }

      vim.keymap.set("n", "<leader>dp", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dr", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>ds", dap.step_into)
      -- vim.keymap.set("n", "<leader>do", dap.step_over)
      -- vim.keymap.set("n", "<F4>", dap.step_out)
      -- vim.keymap.set("n", "<F5>", dap.step_back)
      -- vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
