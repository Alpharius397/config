local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach

local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'ts_ls', 'jsonls', 'eslint' }

local function goError()

  local sw = vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })
  local et = vim.api.nvim_get_option_value("expandtab", { scope = "local" })

  local indent
  if et then
    indent = sw
  else
    indent = 4
  end

  local snippet = "if err != nil {\n\t\n}"

  vim.api.nvim_paste(snippet, false, -1)

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, {row - 1, col+indent})

end

lspconfig.gopls.setup {
  on_attach = function (client, buffer)
    on_attach(client, buffer)

    vim.keymap.set('i', '<C-e>', goError, { noremap=true, silent=true })
  end,
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
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
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
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local ignore = " # type: ignore"
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { ignore })
end

for _, lsp in ipairs(pythonServer) do
  lspconfig[lsp].setup {
    on_attach = function (client, buffer)
      on_attach(client, buffer)

      vim.keymap.set('i', '<C-t>', type_ignore, {noremap= true, silent = true})

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
