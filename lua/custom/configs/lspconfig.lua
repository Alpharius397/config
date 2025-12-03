local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach

local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local lspaction = require("custom.configs.lspaction")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'eslint' }

local jsonServer = { "jsonls" }

local normalConfigLsp = { "cssls", "html", "djlsp" }

local function ts_on_attach(client, buffer)
  vim.keymap.set('n', '<leader>je', lspaction.tsExpectError,
    { noremap = true, silent = true, desc = "insert expects-errors" })
  vim.keymap.set('n', '<leader>ji', lspaction.tsIgnoreError,
    { noremap = true, silent = true, desc = "insert ignore-errors" })
  vim.keymap.set('n', '<leader>jc', lspaction.jsDocComment, { noremap = true, silent = true, desc = "insert jsDoc" })
  vim.keymap.set('n', '<leader>pe', lspaction.expressComment, { noremap = true, silent = true, desc = "insert express/server comment" })
  on_attach(client, buffer)
end

lspconfig.gopls.setup {
  on_attach = function(client, buffer)
    vim.keymap.set('n', '<leader>ee', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
    vim.keymap.set('i', '<C-e>', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
    on_attach(client, buffer)
  end,

  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  }
}

lspconfig.clangd.setup {
  on_attach = function(client, buffer)
    on_attach(client, buffer)
  end,
  capabilities = capabilities,
  filetypes = { "c", "cpp" }
}

for _, lsp in ipairs(pythonServer) do
  lspconfig[lsp].setup {
    on_attach = function(client, buffer)
      on_attach(client, buffer)

      vim.keymap.set('n', '<leader>tt', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
      vim.keymap.set('i', '<C-t>', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
    end,
    capabilities = capabilities,
    filetypes = { "python" },
  }
end

for _, lsp in ipairs(normalConfigLsp) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "css", "html" }
  }
end

lspconfig.postgres_lsp.setup {
  cmd = { "postgres-language-server", "lsp-proxy" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sql" },
}

lspconfig.elixirls.setup {
  cmd = { "language_server.sh" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "elixir", "heex", "eex" }
}

lspconfig.bashls.setup {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' }
}

lspconfig.denols.setup {
  on_attach = ts_on_attach,
  root_dir = function(fname)
    return lspaction.deno_root(fname)
  end,
  capabilities = capabilities,
}

lspconfig.ts_ls.setup {
  on_attach = ts_on_attach,
  root_dir = function(fname)
    if lspaction.deno_root(fname) then
      return nil
    end
    return lspaction.node_root(fname)
  end,
}


for _, lsp in ipairs(jsServer) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  }
end

for _, lsp in ipairs(jsonServer) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "json" }
  }
end
