local plugins = {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      {
        window = {
          backdrop = 0.85, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "delve",
        "gopls",
        "golines",
        "goimports",
        "gofumpt",
        "terraform-ls",
        "tflint",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    ft = "go,terrafrom",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    cmd = "Lint",
    event =  "BufWritePost",
    config = function()
      require "custom.configs.nvim-lint"
    end,
    enabled = false,
  },

  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    event = "BufRead",
    dependencies = {
      "mfussenegger/nvim-dap",
      "leoluz/nvim-dap-go",
      "nvim-treesitter/nvim-treesitter"
    },

    init = function()
      vim.fn.sign_define('DapBreakpoint', {text='•', texthl='', linehl='DapBreakpoint', numhl='DapBreakpoint'})
      vim.fn.sign_define('DapStopped', {text='>', texthl='', linehl='', numhl=''})
    end,

    config = function()
      require "custom.configs.dap-ui"
    end
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "delve" }
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
return plugins
