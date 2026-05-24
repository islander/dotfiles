vim.pack.add(
    { "https://github.com/mason-org/mason.nvim.git" }
)
require("mason").setup()

vim.keymap.set('n', '<Leader>mm', '<Cmd>Mason<CR>', { desc = 'Open [m]ason [m]enu' })
