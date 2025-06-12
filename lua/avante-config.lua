local use = require("packer").use

-- Required plugins
use("stevearc/dressing.nvim")
use("MunifTanjim/nui.nvim")
use("MeanderingProgrammer/render-markdown.nvim")

-- Optional dependencies
use("HakonHarnes/img-clip.nvim")
use("zbirenbaum/copilot.lua")

-- Avante.nvim with build process
use("yetone/avante.nvim")

require("avante").setup({})
