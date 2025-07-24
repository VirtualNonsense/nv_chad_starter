require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local lsp_mappings = require "lsp_mappings"
-- Optional: capabilities from nvim-cmp for better completions
local servers = {
  clangd = {},

  texlab = {
    settings = {
      texlab = {
        auxDirectory = "build",
        build = {
          args = { "-pdf", "-shell-escape", "-interaction=nonstopmode", "-synctex=1", "%f" },
          onSave = true,
          forwardSearchAfter = true,
        },
        chktex = {
          onOpenAndSave = true,
        },
        forwardSearch = {
          executable = "zathura",
          args = { "--synctex-forward", "%l:1:%f", "%p" },
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  opts.on_attach = lsp_mappings.on_attach
  -- vim.lsp.config(name, opts)
  lspconfig[name].setup(opts)
end

-- This enables inlay hints globally
vim.lsp.inlay_hint.enable(true)
