require("nvchad.configs.lspconfig").defaults()
-- Optional: capabilities from nvim-cmp for better completions
local servers = {
  clangd = {},
  texlab = {

  }
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

-- This enables inlay hints globally
vim.lsp.inlay_hint.enable(true)
