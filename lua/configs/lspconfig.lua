require("nvchad.configs.lspconfig").defaults()
vim.lsp.config("rust_analyzer", {
  cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
})
local servers = {
  "html",
  "cssls",
  "rust_analyzer",
  "ruff",
  "ruff_lsp",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
