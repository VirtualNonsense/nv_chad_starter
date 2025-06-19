require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i" }, "<c-s>", "<cmd>w<cr>", { desc = "Buffer save" })

-- Move selected lines down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selectetion down" })
-- Move selected lines up in visual mode
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste over selection without overwriting the default register
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })

-- Yank into system clipboard (normal + visual modes)
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
-- Yank line into system clipboard (normal mode)
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete without copying into default register (normal + visual modes)
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

map("n", "<leader>F", function()
  require("conform").format { bufnr = 0 }
end, { desc = "Conform: Format buffer" })

map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code Action" }) -- Search and replace word under cursor across the file, with case-insensitive global replace
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "LSP: Open diagnostic" })
map(
  "n",
  "<leader>rR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and Replace word under cursor accros file" }
)
-- dap
local dap = require "dap"
map("n", "<F5>", dap.continue, { desc = "Debug: start / continue" })
map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
map("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<Leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Toggle conditional Breakpoint" })
