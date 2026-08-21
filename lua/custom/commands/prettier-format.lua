local formatter = require("custom.configs.lsp.formatter")

return {
  load_commands = function()
    vim.api.nvim_create_user_command("Prettier", formatter.prettier_format, { desc = "Run prettier" })
  end
}
