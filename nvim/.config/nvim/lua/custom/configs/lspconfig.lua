local on_attach = function(client, bufnr)
  require("plugins.configs.lspconfig").on_attach(client, bufnr)

  -- In NvChad formating disabled by default, so we expicitly enable it
  -- because null-ls is not maintaned now
  --
  -- see: https://github.com/NvChad/NvChad/issues/2167
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
end
local capabilities = require("plugins.configs.lspconfig").capabilities


local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

------------
-- golang --
------------
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,

  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- originize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    -- vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    vim.lsp.buf.format({timeout_ms=1000})
    -- vim.lsp.buf.format()
  end
})

---------------
-- terrafrom --
---------------
lspconfig.terraformls.setup{}
lspconfig.tflint.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
