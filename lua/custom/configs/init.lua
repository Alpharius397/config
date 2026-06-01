local function LspConfig(table)
  for k, v in pairs(table) do
    vim.lsp.config(k, v)
    vim.lsp.enable(k)
  end
end

local Lsp = require("custom.configs.lspconfig")

for _, lsp in pairs(Lsp) do
  LspConfig(lsp)
end

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.server_capabilities.completionProvider then
--       vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
--     end
--   end,
-- })

vim.diagnostic.config({ virtual_text = true, float = true, virtual_lines = true })
