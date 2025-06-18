require("nvchad.configs.lspconfig").defaults()
-- Optional: capabilities from nvim-cmp for better completions
local servers = {
  pyright = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          typeCheckingMode = "strict", -- or "basic", "off"
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace", -- "openFilesOnly" is faster
        },
      },
    },
  },
  -- ruff = {},
  ruff = {
    -- init_options = {
    --   settings = {
    --     lint = {
    --       preview = true,
    --       enable = true,
    --     },
    --   },
    -- },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

-- read :h vim.lsp.config for changing options of lsp servers
