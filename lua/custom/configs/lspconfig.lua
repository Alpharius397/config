local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach

local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'ts_ls', 'jsonls', 'eslint' }

local function goError()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local cur_line = vim.api.nvim_buf_get_lines(bufnr, row-1, row, false)[1] or ""
  local indent = string.match(cur_line, "^%s*") or ""

  local shift = vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })
  local use_spaces = vim.api.nvim_get_option_value("expandtab", { scope = "local" })

  local indent_unit = (use_spaces and string.rep(" ", shift)) or "\t"

  local block = {
    indent .. "if err != nil {",
    indent .. indent_unit,
    indent .. "}",
  }

  vim.api.nvim_buf_set_lines(bufnr, row-1, row-1, false, block)

  vim.api.nvim_win_set_cursor(0, { row + 1, #indent + #indent_unit })

end

lspconfig.gopls.setup {
  on_attach = function(client, buffer)
    vim.keymap.set('i', '<C-e>', goError, { noremap = true, silent = true })
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
    client.server_capabilities.signatureHelpProvider = false
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
  local ignore = " # type: ignore"
  vim.api.nvim_paste(ignore, false, -1)
end

for _, lsp in ipairs(pythonServer) do
  lspconfig[lsp].setup {
    on_attach = function(client, buffer)
      on_attach(client, buffer)

      vim.keymap.set('i', '<C-t>', type_ignore, { noremap = true, silent = true })
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
