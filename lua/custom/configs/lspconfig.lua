local lspaction = require("custom.configs.lspaction")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'eslint' }

local normalConfigLsp = { "cssls", "html", "djlsp" }

local function ts_on_attach(client, buffer)
  vim.keymap.set('n', '<leader>je', lspaction.tsExpectError,
    { noremap = true, silent = true, desc = "insert expects-errors" })

  vim.keymap.set('n', '<leader>ji', lspaction.tsIgnoreError,
    { noremap = true, silent = true, desc = "insert ignore-errors" })

  vim.keymap.set('n', '<leader>jc', lspaction.jsDocComment, { noremap = true, silent = true, desc = "insert jsDoc" })

  vim.keymap.set('n', '<leader>pe', lspaction.expressComment,
    { noremap = true, silent = true, desc = "insert express/server comment" })

  vim.keymap.set('n', '<leader>jse', lspaction.tsxExpectError,
    { noremap = true, silent = true, desc = "insert tsx expects-errors" })

  vim.keymap.set('n', '<leader>jsi', lspaction.tsxIgnoreError,
    { noremap = true, silent = true, desc = "insert tsx ignore-errors" })

  vim.keymap.set('n', '<leader>jd', lspaction.eslintTsDisable,
    { noremap = true, silent = true, desc = "insert ts eslint disable" })

  vim.keymap.set('n', '<leader>jsd', lspaction.eslintTsxDisable,
    { noremap = true, silent = true, desc = "insert tsx eslint disable" })
end

local function LspConfig(table)
  for k, v in pairs(table) do
    vim.lsp.config(k, v)
    vim.lsp.enable(k)
  end
end

local LSP = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },

  gopls = {
    on_attach = function(client, buffer)
      vim.keymap.set('n', '<leader>ee', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
      vim.keymap.set('i', '<C-e>', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
    end,

    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    }
  },

  clangd = {
    cmd = {
      "clangd",
      "--clang-tidy",
      "--background-index",
      "--enable-config"
    },
    filetypes = { "c", "cpp" }
  },

  postgres_lsp = {
    cmd = { "postgres-language-server", "lsp-proxy" },
    filetypes = { "sql" },
  },

  elixirls = {
    cmd = { "language_server.sh" },
    filetypes = { "elixir" }
  },

  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' }
  },

  -- denols = {
    -- on_attach = ts_on_attach,
    -- root_dir = function(fname)
      -- return lspaction.deno_root(fname)
    -- end,
    -- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  -- },

  ts_ls = {
    on_attach = ts_on_attach,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },

  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
    filetypes = { "json", "jsonc" },
    format = {
      enable = true,
    },
    trailingCommas = "none"
  },

  rust_analyzer = {
    filetypes = { "rust" },
  }
}


for _, lsp in ipairs(pythonServer) do
  local commonConfig = {
    on_attach = function(client, buffer)
      vim.keymap.set('n', '<leader>tt', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
      vim.keymap.set('i', '<C-t>', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
    end,
    filetypes = { "python" },
  }

  LspConfig({
    [lsp] = commonConfig,
  })
end

for _, lsp in ipairs(normalConfigLsp) do
  LspConfig({
    [lsp] = {
      filetypes = { "css", "html" }
    }
  })
end


for _, lsp in ipairs(jsServer) do
  LspConfig({
    [lsp] = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    }
  })
end

LspConfig(LSP)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
    end
  end,
})

vim.diagnostic.config({ virtual_text = true, float = true, virtual_lines = true })
