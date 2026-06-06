-- core
require('config')
require('keymaps')
require('lsp')

-- plugins
require('plugins.gitsigns')
require('plugins.mason')
require('plugins.nvim-lspconfig')
require('plugins.nvim-treesitter')
require('plugins.tokyonight')
require('plugins.lualine')
require('plugins.miniicons')
require('plugins.blink')

-- new UI
require('vim._core.ui2').enable({})
