local use = require("packer").use

use("folke/snacks.nvim")
use("coder/claudecode.nvim")

require("claudecode").setup({})

vim.keymap.set("n", "<leader>kc", "<cmd>ClaudeCode<cr>")
vim.keymap.set("n", "<leader>kr", "<cmd>ClaudeCode --resume<cr>")
vim.keymap.set("n", "<leader>kC", "<cmd>ClaudeCode --continue<cr>")
vim.keymap.set("v", "<leader>ks", "<cmd>ClaudeCodeSend<cr>")
