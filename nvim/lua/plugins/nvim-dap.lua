return {
  "mfussenegger/nvim-dap",
  -- all carried over from the old custom/mappings.lua dap section
  keys = {
    { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP open repl" },
    { "<leader>ds", function() require("dap").terminate() end, desc = "DAP stop" },
    { "<leader>dn", function() require("dap").step_over() end, desc = "DAP step over" },
    { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "DAP step out" },
    { "<leader>dp", function() require("dap").pause() end, desc = "DAP pause" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
  },
}
