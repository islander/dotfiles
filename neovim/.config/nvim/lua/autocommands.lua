-- helper function
local function augroup(name)
    return vim.api.nvim_create_augroup("ag_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank( { higroup = "IncSearch", timeout = 250 })
    end
})

-- Jenkinsfile is groovy
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("jenkinsfile_detect"),
    pattern = { "Jenkinsfile" },
    callback = function()
        vim.cmd("set filetype=groovy")
    end
})

-- *.tfvars is terraform
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("terraform_detect"),
    pattern = { "*.tfvars" },
    callback = function()
        vim.cmd("set filetype=terraform")
    end
})

-- autoformat go files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
