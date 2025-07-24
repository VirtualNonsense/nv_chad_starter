
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("n", "<leader>mdp", "<cmd>MarkdownPreview<CR>", {
        buffer = true,
        silent = true,
        desc = "Markdown: Preview",
      })
    end,
  })
end

return M
