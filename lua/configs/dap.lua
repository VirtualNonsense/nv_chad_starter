local dap = require "dap"
local dapui = require "dapui"

require("dapui").setup()
require("nvim-dap-virtual-text").setup()

-- Mason integration for installing debuggers
require("mason-nvim-dap").setup {
  ensure_installed = { "python", "codelldb", "delve" },
  handlers = {}, -- leave default handler, or configure per-adapter
}

-- Open DAP UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Python
require("dap-python").setup "/home/anachtmann/.local/share/uv/tools/debugpy/bin/python"

-- Rust / C / C++
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.exepath "codelldb",
    args = { "--port", "${port}" },
  },
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Debug: start / continue" })
vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "Debug: step over" })
vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "Debug: step into" })
vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "Debug: step out" })
vim.keymap.set("n", "<Leader>db", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Toggle conditional Breakpoint" })

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
