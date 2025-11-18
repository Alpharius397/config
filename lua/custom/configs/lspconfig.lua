local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach

local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local util = require("lspconfig.util")

local pythonServer = { "ruff", "pyright" }

local jsServer = { 'tailwindcss', 'jsonls', 'eslint' }

local function goError()
  return "<ESC>oif err != nil {<CR>}<ESC>O"
end

lspconfig.gopls.setup {
  on_attach = function(client, buffer)
    vim.keymap.set('n', '<leader>ee', goError(), { noremap = true, silent = true, desc = "Error Block" })
    vim.keymap.set('i', '<C-e>', goError(), { noremap = true, silent = true, desc = "Error Block" })
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

      vim.keymap.set('n', '<leader>tt', type_ignore(), { noremap = true, silent = true, desc = "Type Ignore" })
      vim.keymap.set('i', '<C-t>', type_ignore(), { noremap = true, silent = true, desc = "Type Ignore" })
    end,
    capabilities = capabilities,
    filetypes = { "python" },
  }
end

local normalConfigLsp = { "cssls", "html", "djlsp" }

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

local function tsExpectError()
  return "<ESC>O//@ts-expect-error "
end

local function tsIgnoreError()
  return "<ESC>O//@ts-ignore "
end

local function jsDocComment()
  return "<ESC>O/**  */<ESC>2hi"
end


local function ts_on_attach(client, buffer)
  vim.keymap.set('n', '<leader>je', tsExpectError(), { noremap = true, silent = true, desc = "insert expects-errors" })
  vim.keymap.set('n', '<leader>ji', tsIgnoreError(), { noremap = true, silent = true, desc = "insert ignore-errors" })
  vim.keymap.set('n', '<leader>jc', jsDocComment(), { noremap = true, silent = true, desc = "insert jsDoc" })
  on_attach(client, buffer)
end

local deno_root = util.root_pattern("deno.json", "deno.jsonc")
local node_root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")

lspconfig.denols.setup {
  on_attach = ts_on_attach,
  root_dir = function(fname)
    return deno_root(fname)
  end,
  capabilities = capabilities,
}

lspconfig.ts_ls.setup {
  on_attach = ts_on_attach,
  root_dir = function(fname)
    if deno_root(fname) then
      return nil
    end
    return node_root(fname)
  end,
  single_file_support = false,
}
