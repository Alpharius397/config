local formatter = require("custom.configs.lsp.formatter")
local utils = require("custom.utils")

return {
  load_commands = function()
    utils.create_user_command("Prettier", formatter.prettier_format, { desc = "Run prettier" })
  end
}
