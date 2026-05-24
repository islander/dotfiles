vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        lazy = false,
        version = 'main',
        run = ':TSUpdate'
    }
})

require('nvim-treesitter').setup({
    ensure_installed = { "go", "lua" },
    highlight = {
        enable = true,
    },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
