local function augroup(name) return vim.api.nvim_create_augroup("ag_" .. name, { clear = true }) end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("filetype_detect"),
    pattern = { "Jenkinsfile" },
    callback = function() vim.cmd("set filetype=groovy") end,
})
