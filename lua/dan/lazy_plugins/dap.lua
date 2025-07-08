return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "leoluz/nvim-dap-go",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
    },

    config = function()
        local dap = require("dap")
        local ui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()
        require("nvim-dap-virtual-text").setup()

        local php_debugger = os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js"
        if php_debugger ~= "" then
            dap.adapters.xdebug_task = {
                type = "executable",
                command = "node",
                args = { php_debugger },
            }

            dap.configurations.php = {
                {
                    type = "xdebug_task",
                    request = "launch",
                    name = "Listen for Xdebug",
                    port = 9003,
                },
            }
        end

        vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

        -- Eval var under cursor
        vim.keymap.set("n", "<space>?", function()
            require("dapui").eval(nil, { enter = true })
        end)

        vim.keymap.set("n", "<F1>", dap.continue)
        vim.keymap.set("n", "<F2>", dap.step_into)
        vim.keymap.set("n", "<F3>", dap.step_over)
        vim.keymap.set("n", "<F4>", dap.step_out)
        vim.keymap.set("n", "<F5>", dap.step_back)
        vim.keymap.set("n", "<F13>", dap.restart)

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
}
