local core = require "core.mappings"
local M = vim.tbl_deep_extend("force", {}, core)

M.dap = {
  n = {
    ["<F5>"] = {
      function()
        require("dap").continue()
      end,
      "DAP continue",
    },
    ["<F10>"] = {
      function()
        require("dap").step_over()
      end,
      "DAP step over",
    },
    ["<F11>"] = {
      function()
        require("dap").step_into()
      end,
      "DAP step into",
    },
    ["<F12>"] = {
      function()
        require("dap").step_out()
      end,
      "DAP step out",
    },
    ["<leader>db"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "DAP toggle breakpoint",
    },
    ["<leader>dB"] = {
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      "DAP conditional breakpoint",
    },
    ["<leader>dc"] = {
      function()
        require("dap").continue()
      end,
      "DAP continue",
    },
    ["<leader>di"] = {
      function()
        require("dap").step_into()
      end,
      "DAP step into",
    },
    ["<leader>do"] = {
      function()
        require("dap").step_over()
      end,
      "DAP step over",
    },
    ["<leader>dO"] = {
      function()
        require("dap").step_out()
      end,
      "DAP step out",
    },
    ["<leader>dt"] = {
      function()
        require("dap").terminate()
      end,
      "DAP terminate",
    },
    ["<leader>du"] = {
      function()
        require("dapui").toggle()
      end,
      "DAP toggle UI",
    },
    ["<leader>dr"] = {
      function()
        require("dapui").open({ reset = true })
      end,
      "DAP open UI",
    },
  },
}

M.dap_python = {
  n = {
    ["<leader>dpt"] = {
      function()
        require("dap-python").test_method()
      end,
      "DAP Python test method",
    },
    ["<leader>dpc"] = {
      function()
        require("dap-python").test_class()
      end,
      "DAP Python test class",
    },
    ["<leader>dpf"] = {
      function()
        require("dap-python").debug_file()
      end,
      "DAP Python debug file",
    },
  },
}

M.dap_go = {
  n = {
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "DAP Go debug test",
    },
    ["<leader>dgl"] = {
      function()
        require("dap-go").debug_last_test()
      end,
      "DAP Go debug last test",
    },
  },
}

local apply = require("custom.utils").applyMappings

apply(M.dap)
apply(M.dap_go)
apply(M.dap_python)
