local key_set = vim.keymap.set
local dap = require "dap"
local dapui = require "dapui"
local nv_text = require("nvim-dap-virtual-text")
local manson_dap = require("mason-nvim-dap")
local python_dap = require("dap-python")
dapui.setup()
nv_text.setup()

-- Mason integration for installing debuggers
manson_dap.setup {
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
python_dap.setup "/home/anachtmann/.local/share/uv/tools/debugpy/bin/python"

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

key_set("n", "<F5>", dap.continue, { desc = "Debug: start / continue" })
key_set("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
key_set("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
key_set("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
key_set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
key_set("n", "<Leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Toggle conditional Breakpoint" })

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
