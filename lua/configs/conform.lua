local options = {
  formatters_by_ft = {
    -- lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    rust = { "rustfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
  },
  formatters = {
    clang_format = {
      prepend_args = { "--style=file", "--fallback-style=LLVM" },
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
