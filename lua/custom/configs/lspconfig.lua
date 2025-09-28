local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach

local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'ts_ls', 'jsonls', 'eslint' }

local function goError()
  return "<ESC>oif err != nil {<CR>}<ESC>O"
end

lspconfig.gopls.setup {
  on_attach = function(client, buffer)
    vim.keymap.set('n', '<leader>ee', goError(), { noremap = true, silent = true })
    vim.keymap.set('i', '<C-e>', goError(), { noremap = true, silent = true })
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
    client.server_capabilities.signatureHelpProvider = 
    on_attach(client, buffer)
  end,
  capabilities = capabilities,
}

for _, lsp in ipairs(jsServer) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local function type_ignore()

  return "<ESC>A #type: ignore<ESC><CR>"
end

for _, lsp in ipairs(pythonServer) do
  lspconfig[lsp].setup {
    on_attach = function(client, buffer)
      on_attach(client, buffer)

      vim.keymap.set('n', '<leader>tt', type_ignore(), { noremap = true, silent = true })
      vim.keymap.set('i', '<C-t>', type_ignore(), { noremap = true, silent = true })
    end,
    capabilities = capabilities,
    filetypes = { "python" },
  }
end

local normalConfigLsp = { "cssls", "html", "djlsp" }

for _, lsp in ipairs(normalConfigLsp) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

lspconfig.postgres_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.elixirls.setup {
  cmd = { "/home/omnissiah/.elixir/elixir-ls/release/language_server.sh" },
}

lspconfig.bashls.setup {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' }
}
