return {
  load_custom = function()
    require("custom.configs.lsp.init").load_lsp()
    require("custom.commands.transparent-bg").load_commands()
    require("custom.commands.prettier-format").load_commands()
    require("custom.commands.make-color-line").load_commands()
  end
}
