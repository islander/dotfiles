vim.pack.add({
    {
        src = "https://www.github.com/olimorris/codecompanion.nvim",
        version = vim.version.range("^18.0.0")
    }
})

require("codecompanion").setup({
    adapters = {
     deepseek = require("codecompanion.adapters").extend("openai", {
       env = {
         api_key = "",
       },
       url = "https://api.deepseek.com/v1/chat/completions",
       schema = {
         model = {
           default = "deepseek-chat",
           choices = {
             "deepseek-coder",
             "deepseek-chat",
           },
         },
         max_token = {
           default = 8192,
         },
         temperature = {
           default = 1,
         },
       },
     }),
  },
  strategies = {
      chat = { adapter = "deepseek", },
      inline = { adapter = "deepseek" },
      agent = { adapter = "deepseek" },
  },
    -- adapters = {
    --     deepseek = function()
    --         return require("codecompanion.adapters").extend("deepseek", {
    --             env = {
    --             },
    --         })
    --     end,
    -- },
    -- strategies = {
    --     chat = { adapter = "deepseek", },
    --     inline = { adapter = "deepseek" },
    --     agent = { adapter = "deepseek" },
    -- },
})
