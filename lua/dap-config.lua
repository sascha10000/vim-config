-- For info check :help dap-configuartion / :help dap-mappings / :help dap-api
-- Debugging Setup
require('dap-go').setup()


local dap = require('dap')
local ui = require "dapui"

ui.setup({
    -- controls = {
    --     element = "preview",
    --     enabled = false,
    -- },
    -- layouts = {
    --     {
    --         elements = {
    --             "scopes",
    --             "breakpoints",
    --             "stacks",
    --             "watches"
    --         },
    --         size = 40, -- Width of the side panel
    --         position = "left"
    --     },
    --     {
    --         elements = {
    --             "repl",
    --             "console"
    --         },
    --         size = 10, -- Height of the bottom panel
    --         position = "bottom"
    --     },
    --     {
    --         elements = {
    --             {
    --                 id = "preview",
    --                 size = 10
    --             },
    --         },
    --         size = 20,
    --         position = "top"
    --     }
    -- }
})

dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    }
}
dap.adapters.go = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/dev/vscode-go/extension/dist/debugAdapter.js' },
}

dap.adapters.firefox = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/dev/vscode-firefox-debug/dist/adapter.bundle.js' },
}

dap.adapters['node-js'] = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/dev/js-debug/src/dapDebugServer.js' },
}

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb', -- adjust as needed, must be absolute path
    name = 'lldb'
}

dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        initCommands = function()
            -- Find out where to look for the pretty printer Python module
            local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

            local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
            local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

            local commands = {}
            local file = io.open(commands_file, 'r')
            if file then
                for line in file:lines() do
                    table.insert(commands, line)
                end
                file:close()
            end
            table.insert(commands, 1, script_import)

            return commands
        end,


        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
    },
}
dap.configurations.go = {
    {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        showLog = false,
        program = "${workspaceFolder}/main.go",
        dlvToolPath = vim.fn.exepath(os.getenv('HOME') .. '/go/bin/dlv') -- Adjust to where delve is installed
    },
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return '/usr/bin/python'
        end,
    },
}

dap.configurations.typescript = {
    {
        name = 'Debug with Firefox',
        type = 'firefox',
        request = 'launch',
        reAttach = true,
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
        firefoxExecutable = '/Applications/Firefox.app/Contents/MacOS/firefox'
    },
    {
        name = 'npm run dap:debug (add dap:debug script to package.json)',
        type = 'node-js',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'npm',
        runtimeArgs = { 'run', 'dap:debug', '--', '--insepect-brk=9229' },
        port = 9229,
    },
    {
        name = 'Attach npm run dap:debug',
        type = 'node-js',
        request = 'attach',
        port = 9229,
        address = 'localhost',
        restart = true,
    },
}

dap.defaults.fallback.external_terminal = {
    command = '/bin/zsh',
    args = { '-e' },
}

dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.terminal_win_cmd = "tabnew"

-- Keymappings
vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gt", dap.run_to_cursor)

-- Eval var under cursor
vim.keymap.set('n', '<leader>ev', function()
    require("dap.repl").eval()
end, { desc = "Eval" })
vim.keymap.set('n', '<leader>zx', function()
    require("dap.ui.widgets").preview()
end, { desc = "Inspect" })

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_over)
vim.keymap.set("n", "<F3>", dap.step_into)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F11>", dap.restart)
vim.keymap.set("n", "<F12>", function()
    dap.terminate()
    ui.close()
end)
vim.keymap.set("n", "<F6>", ui.open)
vim.keymap.set("n", "<F7>", ui.close)

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
