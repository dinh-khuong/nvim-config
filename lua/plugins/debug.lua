return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      -- "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- "jay-babu/mason-nvim-dap.nvim",
      -- "mxsdev/nvim-dap-vscode-js",
      -- 'jonboh/nvim-dap-rr',
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require("dap-vscode-js").setup({
            -- debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
            executable = "js-debug-adapter",
            adapters = {
              "pwa-firefox",
              "chrome",
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
            },
          })
        end,
      },
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"
      dap.set_log_level('TRACE')

      require("dapui").setup()
      -- require("mason-nvim-dap").setup({
      --   ensure_installed = { "chrome", "js" },
      -- })
      -- require("dap-go").setup()

      dap.adapters.chrome = {
        type = "server",
        port = "${port}",
        command = "js-debug-adapter",
      }

      -- local log = io.open("hello.", "a")
      -- if log then
      --   log:write(vim.inspect(dap.adapters.))
      -- end

      -- dap.adapters["pwa-node"] = {
      --   type = "server",
      --   host = "::1",
      --   port = "${port}",
      --   executable = {
      --     command = "js-debug-adapter",
      --     args = { "${port}" },
      --   }
      -- }
      --
      dap.adapters["node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        }
      }

      dap.adapters.ex_lldb = {
        type = 'executable',
        command = 'codelldb'
      }

      dap.adapters.gdb = {
        id = 'gdb',
        type = 'executable',
        command = 'gdb',
        args = { '--quiet', '--interpreter=dap' },
      }

      dap.configurations.rust = {
        {
          type = "ex_lldb",
          request = "launch",
          name = "lldb default launch",
          program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        },
        {
          type = "gdb",
          request = "launch",
          name = "gdb default launch",
          program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        },
      }

      for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
        dap.configurations[language] = {
          -- {
          --   type = 'pwa-node',
          --   request = 'launch',
          --   name = 'Launch file',
          --   program = '${file}',
          --   cwd = '${workspaceFolder}',
          -- },
          {
            type = 'node',
            request = 'launch',
            name = "Launch file node",
            runtimeExecutable = "bun",
            runtimeArgs = { "dev" },
            program = "${file}",
            cwd = "${workspaceFolder}",
            -- attachSimplePort = 9229,
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach to Node app',
            address = 'localhost',
            port = 3000,
            cwd = '${workspaceFolder}',
            restart = true,
          },
          -- {
          --   name = "My chrome",
          --   type = "chrome",
          --   request = "launch",
          --   program = "${file}",
          --   cwd = "${workspaceFolder}",
          --   sourceMaps = true,
          --   protocol = "inspector",
          --   runtimeExecutable = "/usr/bin/chrome",
          --   -- port = ,
          --   webRoot = "${workspaceFolder}"
          -- },
          -- {
          --   type = "pwa-node",
          --   request = "attach",
          --   name = "Launch file",
          --   program = "${file}",
          --   cwd = "${workspaceFolder}",
          --   runtimeExecutable = "node",
          -- },
          {
            -- type = "pwa-chrome",
            type = "chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            runtimeExecutable = "/usr/bin/chrome",
            -- webRoot = vim.fn.getcwd(),
            -- protocol = "inspector",
            -- sourceMaps = true,
            -- userDataDir = false,
          },
        }
      end

      -- dap.adapters["pwa-chrome"] = {
      --   type = "server",
      --   host = "127.0.0.1",
      --   port = 3000,
      --   -- port = function()
      --   --   return vim.fn.input("Select port: ", 9222)
      --   -- end,
      --   executable = {
      --     command = "js-debug-adapter",
      --   }
      -- }
      --
      --
      -- for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      --   require("dap").configurations[language] = {
      --     {
      --       type = "pwa-chrome",
      --       request = "attach",
      --       name = "Attach Program (pwa-chrome, select port)",
      --       program = "${file}",
      --       cwd = vim.fn.getcwd(),
      --       port = 3333,
      --       sourceMaps = true,
      --       webRoot = "${workspaceFolder}",
      --     },
      --   }
      -- end

      vim.keymap.set("n", "<leader>dp", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dr", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>dP", function ()
        dap.set_breakpoint(vim.fn.input({
          prompt = "Condition: ",
        }))
      end)

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>dsi", dap.step_into)
      vim.keymap.set("n", "<leader>dso", dap.step_over)
      vim.keymap.set("n", "<leader>dst", dap.step_out)
      vim.keymap.set("n", "<leader>dsb", dap.step_back)

      vim.api.nvim_create_user_command("DapUIOpen", function ()
        ui.open()
      end, {})

      vim.api.nvim_create_user_command("DapUIClose", function ()
        ui.close()
      end, {})

      -- vim.api.nvim_create_user_command("DapUi", function (args)
      --   if args.args == "open" then
      --     ui.open()
      --   elseif args.args == "close" then
      --     ui.close()
      --   end
      -- end, { nargs = 1, complete = function ()
      --     return {"open", "close"}
      -- end
      --   }
      -- )
      -- vim.keymap.set("n", "<leader>dr", dap.restart)

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


-- return {
--   {
--     "mfussenegger/nvim-dap",
--     dependencies = {
--       "rcarriga/nvim-dap-ui",
--       "mxsdev/nvim-dap-vscode-js",
--       -- build debugger from source
--       {
--         "microsoft/vscode-js-debug",
--         version = "1.x",
--         build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
--       }
--     },
--     keys = {
--       -- normal mode is default
--       { "<leader>d", function() require 'dap'.toggle_breakpoint() end },
--       { "<leader>c", function() require 'dap'.continue() end },
--       { "<C-'>",     function() require 'dap'.step_over() end },
--       { "<C-;>",     function() require 'dap'.step_into() end },
--       { "<C-:>",     function() require 'dap'.step_out() end },
--     },
--     config = function()
--       require("dap-vscode-js").setup({
--         debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
--         adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'firefox' },
--       })
--
--       for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
--         require("dap").configurations[language] = {
--           -- attach to a node process that has been started with
--           -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
--           -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
--           {
--             -- use nvim-dap-vscode-js's pwa-node debug adapter
--             type = "pwa-node",
--             -- attach to an already running node process with --inspect flag
--             -- default port: 9222
--             request = "attach",
--             -- allows us to pick the process using a picker
--             processId = require 'dap.utils'.pick_process,
--             -- name of the debug action you have to select for this config
--             name = "Attach debugger to existing `node --inspect` process",
--             -- for compiled languages like TypeScript or Svelte.js
--             sourceMaps = true,
--             -- resolve source maps in nested locations while ignoring node_modules
--             resolveSourceMapLocations = {
--               "${workspaceFolder}/**",
--               "!**/node_modules/**" },
--             -- path to src in vite based projects (and most other projects as well)
--             cwd = "${workspaceFolder}/src",
--             -- we don't want to debug code inside node_modules, so skip it!
--             skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
--           },
--           {
--             type = "pwa-chrome",
--             name = "Launch Chrome to debug client",
--             request = "launch",
--             url = "http://localhost:5173",
--             sourceMaps = true,
--             protocol = "inspector",
--             port = 9222,
--             webRoot = "${workspaceFolder}/src",
--             -- skip files from vite's hmr
--             skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
--           },
--           -- only if language is javascript, offer this debug action
--           language == "javascript" and {
--             -- use nvim-dap-vscode-js's pwa-node debug adapter
--             type = "pwa-node",
--             -- launch a new process to attach the debugger to
--             request = "launch",
--             -- name of the debug action you have to select for this config
--             name = "Launch file in new node process",
--             -- launch current file
--             program = "${file}",
--             cwd = "${workspaceFolder}",
--           } or nil,
--         }
--       end
--
--       require("dapui").setup()
--       local dap, dapui = require("dap"), require("dapui")
--       dap.listeners.after.event_initialized["dapui_config"] = function()
--         dapui.open({ reset = true })
--       end
--       dap.listeners.before.event_terminated["dapui_config"] = dapui.close
--       dap.listeners.before.event_exited["dapui_config"] = dapui.close
--     end
--   }
-- }
