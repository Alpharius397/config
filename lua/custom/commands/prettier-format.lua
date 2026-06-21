local formatter = require("custom.configs.lsp.formatter")

return {
  load_commands = function()
    vim.api.nvim_create_user_command("Prettier", formatter.prettier_forma, { desc = "Run prettier" })
  end
}
