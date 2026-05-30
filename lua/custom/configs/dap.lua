local M = {}

M.setup_ui = function()
  local dap = require "dap"
  local dapui = require "dapui"

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

M.setup_python = function()
  local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
  require("dap-python").setup(path)
end

return M
