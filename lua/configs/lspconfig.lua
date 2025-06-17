require("nvchad.configs.lspconfig").defaults()
local servers = {
  html = {},
  cssls = {},
  rust_analyzer = {},
  --pylsp = {},
  pyright = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      python = {
        -- analysis = {
        --   -- Ignore all files for analysis to exclusively use Ruff for linting
        --   ignore = { "*" },
        -- },
      },
    },
  },
  basedpyright = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true,
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
