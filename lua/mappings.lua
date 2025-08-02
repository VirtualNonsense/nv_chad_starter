require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set

-- Global mappings
map("n", ";", ":", { desc = "CMD: enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Buffer: Save" })

-- Disable annoying Ctrl-Z
map("n", "<C-z>", "<nop>", { desc = "Disabled: Suspend" })
-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clipboard + delete behavior
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

-- Formatting
map({"n", "i"}, "<A-f>", function()
  require("conform").format { bufnr = 0 }
end, { desc = "Conform: Format buffer" })

-- DAP
local dap = require "dap"
map({"n", "i", "v"}, "<F5>", dap.continue, { desc = "Debug: Continue" })
map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
map("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
map("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
map("n", "<Leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Debug: Conditional Breakpoint" })

-- Search & replace
map(
  "n",
  "<leader>rR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor in file" }
)
