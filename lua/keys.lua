vim = vim

vim.g.mapleader = " "

-- deactivate arrow keys
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- custom
vim.keymap.set('v', '<leader>y', ':y*<CR>')

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files { path_display = { "truncate" } }
end)
vim.keymap.set('n', '<C-ff>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > "), path_display = { "truncate" } });
end)
vim.keymap.set('n', '<leader>fd', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', function()
    builtin.buffers { path_display = { "truncate" } }
end)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.git_status, {})

-- Space PV back
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


-- Vimspector
--vim.cmd([[
--nmap <F9> <cmd>call vimspector#Launch()<cr>
--nmap <F5> <cmd>call vimspector#StepOver()<cr>
--nmap <F8> <cmd>call vimspector#Reset()<cr>
--nmap <F11> <cmd>call vimspector#StepOver()<cr>")
--nmap <F12> <cmd>call vimspector#StepOut()<cr>")
--nmap <F10> <cmd>call vimspector#StepInto()<cr>")
--]])

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Angular shortcuts
local opts = { noremap = true, silent = true }
local ng = require("ng")
vim.keymap.set("n", "<leader>at", ng.goto_template_for_component, opts)
vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file, opts)
vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, opts)

-- Trouble
vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<cr>", opts)
vim.keymap.set("n", "<leader>xt", ":Telescope diagnostics<cr>", opts)

-- ZenMode
vim.keymap.set("n", "<leader>zm", ":ZenMode<cr>", opts)

-- YANK LSP Diagnostic error
-- vim.api.nvim_set_keymap('n', '<leader>e', [[:lua YankDiagnosticError()<CR>]],
--     { noremap = true, silent = true, desc = "Copy error" })
--
-- function YankDiagnosticError()
--     vim.diagnostic.open_float()
--     vim.diagnostic.open_float()
--     local win_id = vim.fn.win_getid()    -- get the window ID of the floating window
--     vim.cmd("normal! j")                 -- move down one row
--     vim.cmd("normal! VG")                -- select everything from that row down
--     vim.cmd("normal! <leader>y")         -- yank selected text
--     vim.api.nvim_win_close(win_id, true) -- close the floating window by its ID
-- end
