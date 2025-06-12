local use = require("packer").use

use("folke/snacks.nvim")
use("coder/claudecode.nvim")

require("claudecode").setup({})

vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>")
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>")
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>")
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>")
