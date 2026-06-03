local plugins = {
  {
    "b0o/SchemaStore.nvim",
    lazy = false,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("custom.configs.dap.init").setup_ui()
      require("core.utils").load_mappings "dap"
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("custom.configs.dap.init").setup_python()
      require("core.utils").load_mappings "dap_python"
    end,
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-go").setup()
      require("core.utils").load_mappings "dap_go"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "autotools-language-server",
        "bash-language-server",
        "black",
        "clangd",
        "css-lsp",
        "debugpy",
        "delve",
        "django-template-lsp",
        "djlint",
        "eslint_d",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "mypy",
        "postgres-language-server",
        "prettier",
        "pyright",
        "ruff",
        "rust-analyzer",
        "shfmt",
        "sql-formatter",
        "sqls",
        "tailwindcss-language-server",
        "tsgo",
        "typescript-language-server",
      },
    },
  },
}

return plugins
