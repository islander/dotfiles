vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim.git" },
})
require("lualine").setup({
    options = { theme = "tokyonight" },
})
