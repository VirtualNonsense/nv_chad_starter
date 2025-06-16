require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i" }, "<c-s>", "<cmd>w<cr>", { desc = "Buffer save" })

-- Move selected lines down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selectetion down" })
-- Move selected lines up in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste over selection without overwriting the default register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })

-- Yank into system clipboard (normal + visual modes)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
-- Yank line into system clipboard (normal mode)
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete without copying into default register (normal + visual modes)
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

vim.keymap.set("n", "<leader>F", function()
    require("conform").format { bufnr = 0 }
  end, { desc = "Conform: Format buffer" }) 



