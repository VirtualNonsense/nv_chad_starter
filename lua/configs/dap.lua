local dap = require "dap"
local dapui = require "dapui"
local nv_text = require "nvim-dap-virtual-text"
local manson_dap = require "mason-nvim-dap"
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

-- Rust / C / C++
local extension_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"

if vim.fn.filereadable(codelldb_path) == 0 then
  error("codelldb binary not found at " .. codelldb_path)
end
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
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
dap.configurations.rust = dap.configurations.cpp
dap.configurations.c = dap.configurations.cpp
