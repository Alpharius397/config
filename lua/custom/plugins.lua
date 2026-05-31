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
      require("custom.configs.dap").setup_ui()
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
      require("custom.configs.dap").setup_python()
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
        "clangd",
        "gopls",
        "postgres-language-server",
        "ruff",
        "rust-analyzer",
        "lua-language-server",
        "django-template-lsp",
        "djlint",
        "debugpy",
        "typescript-language-server",
        "tailwindcss-language-server",
        "black",
        "pyright",
        "prettier",
        "json-lsp",
        "html-lsp",
        "delve",
        "css-lsp",
        "bash-language-server",
        "eslint_d",
        "elixir-ls",
        "autotools-language-server",
        "marksman",
        "mypy",
        "shfmt",
        "sql-formatter",
        "sqls",
      },
    },
  },
}

return plugins
